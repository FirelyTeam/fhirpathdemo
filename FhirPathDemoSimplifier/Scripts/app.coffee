# CoffeeScript
#require('file?name=/index.html!jade-env-html!./index.jade')

#require('ng-cache?!jade-env-html!./404.jade')
#require('ng-cache?!jade-env-html!./_index.jade')
#require('./Content/app.less')
#require('angular-ui-codemirror')

#fpath = require('../fhirpath.js/build/bundle.js')
# console.log(fpath)

app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
  'firebase'
])

app.run ($rootScope, $window) ->
  console.log('run')

app.config ($routeProvider) ->
  rp = $routeProvider
  rp.when '/',
    name: 'index'
    templateUrl: '_index.jade'
    controller: 'IndexCtrl'
    reloadOnSearch: false
  rp.otherwise templateUrl: '404.jade'



app.controller 'IndexCtrl', ($scope, $firebaseObject) ->

  fbRef = new Firebase("https://fhirpath.firebaseio.com/")
  $scope.examples = $firebaseObject(fbRef);

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


  $scope.saveExample = ()->
    $scope.saving = "Saving..."
    Save path: $scope.path, name: $scope.exampleName, resource: $scope.resource, ->
      $scope.saving = null

  $scope.path = 'Patient.name.given |  Patient.name.given'
  $scope.resource = '{"resourceType": "Patient", "name": [{"given": ["John"]}]}'
  $scope.update = ()->
    try
      resource = JSON.parse($scope.resource)
      $scope.parseError = null
    catch e
      $scope.parseError = e.toString()
      return

    try
      #result=fpath(resource, $scope.path)
      result = webpackUniversalModuleDefinition(resource, $scope.path)
      $scope.result = JSON.stringify(result[1], null, "  ")
      $scope.errors = null
    catch e
      if e.errors
        $scope.errors = e.errors
        console.log("ERROR", e.errors)
      else
        $scope.error = e.toString()
        # throw e
  $scope.update()

  $scope.selectExample = (ex)->
    $scope.resource = ex.resource
    $scope.path = ex.path
    $scope.exampleName = ex.name
    $scope.update()

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

