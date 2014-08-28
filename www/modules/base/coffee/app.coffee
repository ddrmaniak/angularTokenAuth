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

