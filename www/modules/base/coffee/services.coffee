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