
app.controller 'IndexCtrl', ($scope, $firebaseObject, fhirServer, resourceIdentityModel) ->        
          
  fpath = null
  require(['Client/app/vendor/fhirpath.js/bundle.js'], (fhirpath) ->
     fpath = fhirpath; 
  );
      
  $scope.isDemoMode = resourceIdentityModel == null; 
  
  $scope.goToDemoMode = () ->
    resetValues();
    fbRef = new Firebase("https://fhirpath.firebaseio.com/")
    $scope.examples = $firebaseObject(fbRef);
    $scope.path = 'Patient.name.given |  Patient.name.given'
    $scope.resource = '{"resourceType": "Patient", "name": [{"given": ["John"]}]}'
    $scope.isDemoMode = true;
     
  $scope.goToResource = () ->
    resetValues();
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
    $scope.isDemoMode = false;
  
  $scope.saveExample = ()->
    $scope.saving = "Saving..."
    Save path: $scope.path, name: $scope.exampleName, resource: $scope.resource, ->
      $scope.saving = null
          
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
     
  $scope.selectExample = (ex)->
    $scope.resource = ex.resource
    $scope.path = ex.path
    $scope.exampleName = ex.name
    $scope.update()

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
    
  Save = (data, cb)->
    return unless data or data.name
    ref = new Firebase("https://fhirpath.firebaseio.com/#{data.name}")
    obj = $firebaseObject(ref);
    obj.$loaded().then ->
      console.log("loaded", obj)
      obj.path = data.path
      obj.name = data.name
      obj.resource = data.resource
      obj.$save().then ->
        cb()
  
  resetValues = () ->
    $scope.path = "";
    $scope.resource = "";
    $scope.result = "";
    $scope.errors = null;
       
  resetValues();
  if $scope.isDemoMode
    $scope.goToDemoMode()
  else
    $scope.goToResource()