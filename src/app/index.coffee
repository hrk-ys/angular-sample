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
    scope: {
      title: '@'
      last_access_at: '=lastAccessAt'
    }
    controller: 'Timeline'

  .filter 'timeago', () ->
    (input) ->
      diff = parseInt((new Date)/1000) - input
      t = [
        ['秒前', 60],
        ['分前', 60],
        ['時間前', 60],
        ['日前', 24]
      ]

      str = ''
      angular.forEach t, (v) ->
        if diff > 0
          str = diff + v[0]
          diff = parseInt(diff / v[1])
      str

  .filter 'cindex', () ->
    (input) ->
      ("00" + input).substr(-3)
