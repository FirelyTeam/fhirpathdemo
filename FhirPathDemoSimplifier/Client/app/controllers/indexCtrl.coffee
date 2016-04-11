
app.controller 'IndexCtrl', ($scope, fhirServer, resourceIdentityModel) ->        
          
  fpath = null
  require(['Client/app/vendor/fhirpath.js/bundle.js'], (fhirpath) ->
     fpath = fhirpath; 
  );
  
  server = fhirServer(resourceIdentityModel.BaseUrl);      
   
  server.read(
        id: resourceIdentityModel.ResourceId
        resourceType: resourceIdentityModel.ResourceType
        success: (data) -> 
            $scope.resource = JSON.stringify(data, null, 4);
            $scope.$apply('doMapping()')
        error: (error) ->
            console.log(error)
    );
    
  $scope.showReturnButton = () ->
    resourceIdentityModel.CallbackUrl != null  
    
  $scope.goBack = () ->
    window.location = resourceIdentityModel.CallbackUrl;
            
  $scope.update = () ->
    try
      resource = JSON.parse($scope.resource)
      $scope.parseError = null
    catch e
      $scope.parseError = e.toString()
      return

    try
      result = fpath.evaluate(resource, $scope.path);
      $scope.result = JSON.stringify(result, null, "  ")
      $scope.errors = null
      $scope.error = null
      $scope.successMessage = "Your fluent path compliles correctly."
    catch e
      if e.errors
        $scope.successMessage = null
        $scope.error = null
        $scope.errors = e.errors
        console.log("ERROR", e.errors)
      else
        $scope.successMessage = null
        $scope.errors = null;
        $scope.error = e.toString()
        # throw e
     
  $scope.codemirrorConfig = 
    lineWrapping: false
    lineNumbers: true
    mode: 'javascript'
    extraKeys: window.CodeMirror.normalizeKeyMap
        "Ctrl-Space": () ->
          $scope.$apply('doMapping()')
        Tab: (cm) ->
          cm.replaceSelection("  ")
    viewportMargin: Infinity
            
    