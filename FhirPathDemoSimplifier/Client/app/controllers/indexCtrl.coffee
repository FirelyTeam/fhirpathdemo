
app.controller 'IndexCtrl', ($scope, fhirServer, resourceReferenceModel) ->        
    
  fpath = null
  require(['Client/app/vendor/fhirpath.js/bundle.js'], (fhirpath) ->
     fpath = fhirpath; 
  );
    
  $scope.path = "";
  $scope.resource = "";
  
  fhirServer(resourceReferenceModel.BaseUrl).read(
    id: resourceReferenceModel.ResourceId
    resourceType: resourceReferenceModel.ResourceType
    success: (data) -> 
        $scope.resource = JSON.stringify(data);
        $scope.$apply('doMapping()')
    error: (error) ->
        console.log(error)
  );
  
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
    catch e
      if e.errors
        $scope.errors = e.errors
        console.log("ERROR", e.errors)
      else
        $scope.error = e.toString()
        # throw e
      
  codemirrorExtraKeys = window.CodeMirror.normalizeKeyMap
    "Ctrl-Space": () ->
      $scope.$apply('doMapping()')

    Tab: (cm) ->
      cm.replaceSelection("  ")

  $scope.codemirrorConfig =
    lineWrapping: false
    lineNumbers: true
    mode: 'javascript'
    extraKeys: codemirrorExtraKeys,
    viewportMargin: Infinity
