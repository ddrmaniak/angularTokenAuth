(function() {
  var APIService, AdminUserCtrl, AuthenticationService, LoggedInCtrl, TokenInterceptor, UserService;

  angular.module('my_app', ['my_app.appControllers', 'my_app.appServices', 'ngAnimate', 'ui.router']).config(function($stateProvider, $urlRouterProvider, $httpProvider) {
    $stateProvider.state('main', {
      url: '',
      templateUrl: 'modules/base/templates/authPOST.html'
    }).state('loggedIn', {
      url: '/loggedin',
      templateUrl: 'modules/base/templates/loggedIn.html'
    }).state('loggedIn.pages', {
      views: {
        'logged@loggedIn': {
          templateUrl: 'modules/base/templates/logged.html'
        },
        'teachers@loggedIn': {
          templateUrl: 'modules/base/templates/teacherList.html'
        },
        'students@loggedIn': {
          templateUrl: 'modules/base/templates/studentList.html'
        }
      },
      controller: 'LoggedInCtrl'
    });
    $httpProvider.interceptors.push("TokenInterceptor");
  }).run(function($rootScope, $location, AuthenticationService) {
    $rootScope.$on("$routeChangeStart", function(event, nextRoute, currentRoute) {
      if (nextRoute.access.requiredLogin && !AuthenticationService.isLogged) {
        $rootScope.$state = 'my_app.loggedIn';
      }
    });
  });

  AdminUserCtrl = function($http, $rootScope, $scope, $location, $window, UserService, AuthenticationService) {
    var logIn, logout;
    $scope.logIn = logIn = function(username, password) {
      if (username !== undefined && password !== undefined) {
        UserService.logIn(username, password).success(function(data) {
          AuthenticationService.isLogged = true;
          $window.sessionStorage.token = data.token;
          $location.path("/loggedin");
        }).error(function(status, data) {
          console.log(status);
          console.log(data);
        });
      }
    };
    return $scope.logout = logout = function() {
      if (AuthenticationService.isLogged) {
        AuthenticationService.isLogged = false;
        delete $window.sessionStorage.token;
        $location.path("");
      }
    };
  };

  LoggedInCtrl = function($window, $scope, $http, APIService, $rootScope) {
    $scope.myToken = $window.sessionStorage.token;
    $scope.changeView = function(view) {};
    $scope.getTeachers = APIService.request("teachers").success(function(data) {
      $scope.teachers = data;
    }).error(function(status, data) {
      console.log(status);
      console.log(data);
    });
    return $scope.getStudents = APIService.request("students").success(function(data) {
      $scope.students = data;
    }).error(function(status, data) {
      console.log(status);
      console.log(data);
    });
  };

  angular.module('my_app.appControllers', ['my_app.appServices']).controller("AdminUserCtrl", AdminUserCtrl).controller("LoggedInCtrl", LoggedInCtrl);

  AuthenticationService = function() {
    var auth;
    auth = {
      isLogged: false
    };
    return auth;
  };

  UserService = function($http) {
    return {
      logIn: function(username, password) {

        /*
        options.api.base_url
         */
        return $http.post("http://127.0.0.1:8000" + "/api-token-auth/", {
          username: username,
          password: password
        });
      },
      logOut: function() {}
    };
  };

  TokenInterceptor = function($q, $window, AuthenticationService) {
    return {
      request: function(config) {
        config.headers = config.headers || {};
        if ($window.sessionStorage.token) {
          config.headers.Authorization = "Token " + $window.sessionStorage.token;
        }
        return config;
      },
      response: function(response) {
        return response || $q.when(response);
      }
    };
  };

  APIService = function($http) {
    return {
      request: function(what) {
        return $http.get("http://127.0.0.1:8000/" + what + "/?format=json");
      }
    };
  };

  angular.module('my_app.appServices', []).service('APIService', APIService).service('AuthenticationService', AuthenticationService).service('UserService', UserService).factory("TokenInterceptor", TokenInterceptor);

}).call(this);

//# sourceMappingURL=app.js.map
