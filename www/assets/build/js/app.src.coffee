
angular
.module 'my_app', [
    'my_app.appControllers'
    'my_app.appServices'
    'ngAnimate'
    'ui.router'
]
.config ($stateProvider, $urlRouterProvider, $httpProvider)->
    $stateProvider

    .state 'main', {
        url: ''
        templateUrl: 'modules/base/templates/authPOST.html'
    }

    .state 'loggedIn',{
        url: '/loggedin'
        templateUrl: 'modules/base/templates/loggedIn.html'
    } 
    .state 'loggedIn.pages', {
        views:
            'logged@loggedIn':
                templateUrl: 'modules/base/templates/logged.html'   
            'teachers@loggedIn':
                templateUrl: 'modules/base/templates/teacherList.html'
            'students@loggedIn':
                templateUrl: 'modules/base/templates/studentList.html' 
        controller: 'LoggedInCtrl'
    }
    $httpProvider.interceptors.push "TokenInterceptor"
    return

.run ($rootScope, $location, AuthenticationService) ->
    $rootScope.$on "$routeChangeStart", (event, nextRoute, currentRoute) ->
        $rootScope.$state = 'my_app.loggedIn'  if nextRoute.access.requiredLogin and not AuthenticationService.isLogged
        return
    return



AdminUserCtrl = ($http, $rootScope, $scope, $location, $window, UserService, AuthenticationService) ->
    
  #Admin User Controller (login, logout)
  $scope.logIn = logIn = (username, password) ->
    if username isnt `undefined` and password isnt `undefined`
      UserService.logIn(username, password).success((data) ->
        AuthenticationService.isLogged = true
        $window.sessionStorage.token = data.token
        #$http.defaults.headers.common['Authorization'] = "Token " + data.token
        $location.path "/loggedin"
        return
      ).error (status, data) ->
        console.log status
        console.log data
        return

    return

  $scope.logout = logout = ->
    if AuthenticationService.isLogged
      AuthenticationService.isLogged = false
      delete $window.sessionStorage.token
      #delete $http.defaults.headers.common.Authorization
      $location.path ""
    return

LoggedInCtrl = ($window, $scope, $http, APIService, $rootScope) ->

  $scope.myToken = $window.sessionStorage.token

  $scope.changeView = (view) ->
    #todo: write the function
    return

  $scope.getTeachers = 
    APIService.request("teachers").success((data) ->
      $scope.teachers = data
      return
    ).error (status, data) ->
      console.log status
      console.log data
      return

  $scope.getStudents = 
    APIService.request("students").success((data) ->
      $scope.students = data
      return
    ).error (status, data) ->
      console.log status
      console.log data
      return

angular
.module 'my_app.appControllers', ['my_app.appServices']
.controller "AdminUserCtrl", AdminUserCtrl
.controller "LoggedInCtrl", LoggedInCtrl
AuthenticationService = ->
    auth = isLogged: false
    auth

UserService = ($http) ->
    logIn: (username, password) ->

        ###
        options.api.base_url
        ###
        $http.post "http://127.0.0.1:8000"+ "/api-token-auth/",
          username: username,
          password: password
    logOut: -> 

TokenInterceptor = ($q, $window, AuthenticationService) ->
  request: (config) ->
    config.headers = config.headers or {}
    config.headers.Authorization = "Token #{$window.sessionStorage.token}" if $window.sessionStorage.token
    config

  response: (response) ->
    response or $q.when(response)


APIService =  ($http) ->
  request: (what) ->
    $http.get "http://127.0.0.1:8000/" + what + "/?format=json"

angular
.module 'my_app.appServices', []
.service 'APIService', APIService
.service 'AuthenticationService', AuthenticationService
.service 'UserService', UserService

.factory "TokenInterceptor", TokenInterceptor