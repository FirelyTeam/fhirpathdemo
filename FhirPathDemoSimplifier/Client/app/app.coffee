
window.app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
  'firebase'
]) 
    
app.factory "fhirServer", () ->  
  fhirServer = (url) ->
    clientConfig = 
        baseUrl: url
    client = fhir(clientConfig, jqAdapter);
    client
  fhirServer
      
app.run ($rootScope, $window) ->
  console.log('run')
  
app.config ($routeProvider) ->
  rp = $routeProvider
  rp.when '/',
    name: 'index'
    templateUrl: 'Client/app/partials/_index.html'
    controller: 'IndexCtrl'  
    reloadOnSearch: false
  rp.otherwise templateUrl: 'Client/app/partials/404.html'
  
  