
app.controller 'DemoCtrl', ($scope, $firebaseObject) ->
    
  fpath = null;
  require(['Client/app/vendor/fhirpath.js/bundle.js'], (fhirpath) ->
     fpath = fhirpath; 
     $scope.update();
  );
  
  fbRef = new Firebase("https://fhirpath.firebaseio.com/")
  $scope.examples = $firebaseObject(fbRef);
  $scope.path = 'Patient.name.given |  Patient.name.given'
  $scope.resource = '{"resourceType": "Patient", "name": [{"given": ["John"]}]}'
  
  $scope.saveExample = ()->
    $scope.saving = "Saving..."
    Save path: $scope.path, name: $scope.exampleName, resource: $scope.resource, ->
      $scope.saving = null
  
  $scope.update = ()->
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
