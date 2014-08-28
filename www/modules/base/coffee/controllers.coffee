
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