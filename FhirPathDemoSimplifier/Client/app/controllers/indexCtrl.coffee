
app.controller 'IndexCtrl', ($scope, fhirServer, resourceIdentityModel) ->        
          
  fpath = null
  require(['Client/app/vendor/fhirpath.js/bundle.js'], (fhirpath) ->
     fpath = fhirpath; 
  );
  Common.showLoading($('#resoruceInputContainer'));
  server = fhirServer(resourceIdentityModel.BaseUrl);      
   
  server.read(
        id: resourceIdentityModel.ResourceId
        resourceType: resourceIdentityModel.ResourceType
        success: (data) -> 
            $scope.resource = JSON.stringify(data, null, 4);     
            $scope.update();
            $scope.$apply('doMapping()')
            Common.hideLoading($('#resoruceInputContainer'));
        error: (error) ->
            Common.hideLoading($('#resoruceInputContainer'));
            console.log(error)
    );
    
  $scope.showReturnButton = () ->
    resourceIdentityModel.CallbackUrl != null  
    
  $scope.goBack = () ->
    window.location = resourceIdentityModel.CallbackUrl;
            
  $scope.update = () ->
    if $scope.path is  undefined or $scope.path is "" 
        $scope.successMessage = "You can enter your FhirPath in the input field above.";
    else if $scope.resource is undefined or $scope.resource is "" 
        $scope.result = null;
        $scope.successMessage = "You can enter your FhirPath expression below.";
    else
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
          $scope.successMessage = "Your FhirPath compiles correctly."
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
            
    