
window.app = angular.module('app', [
  'ngCookies'
  'ngRoute'
  'ngAnimate'
  'ui.codemirror'
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
    resolve: {
        resourceIdentityModel: (resourceIdentityModel, $location) ->
            if resourceIdentityModel == null
                $location.path("error")
            else 
                resourceIdentityModel
    }
    reloadOnSearch: false
  rp.otherwise templateUrl: 'Client/app/partials/404.html'
  
  