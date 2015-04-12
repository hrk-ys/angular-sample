angular.module 'angularSample', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'ui.bootstrap', 'angularLocalStorage']
  .config ($locationProvider, $stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        url: "/",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"

      .state "room",
        url: "/room",
        templateUrl: "app/main/room.html",
        controller: "RoomCtl"

      .state "signup",
        templateUrl: "app/signup/layout.html"

      .state "signup.email",
        url: "/signup",
        templateUrl: "app/signup/email.html",
        controller: "SignupEmail"

      .state "signup.pin",
        url: "/signup/pin",
        templateUrl: "app/signup/pin.html",
        controller: "SignupPin"

    $urlRouterProvider.otherwise '/'

    $locationProvider.html5Mode(true)

  .run ($rootScope, $location, User) ->

    $rootScope.$on '$stateChangeStart', () ->
      console.log('root change : ' + $location.path())
      if User.is_auth
        if $location.path().match(/^\/signup/)
          $location.path('/')
        return
      if !$location.path().match(/^\/signup/)
        $location.path('/signup')


  .directive 'timeline', ()->
    restrict: 'EA'
    templateUrl: 'app/main/timeline.html',
    scope: false
    controller: 'Timeline'
