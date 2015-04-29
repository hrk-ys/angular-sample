angular.module 'angularSample', ['ngAnimate', 'ngCookies', 'ngTouch', 'ngSanitize', 'ngResource', 'ui.router', 'ui.bootstrap', 'angularLocalStorage']
  .config ($locationProvider, $stateProvider, $urlRouterProvider) ->
    $stateProvider
      .state "home",
        templateUrl: "app/main/main.html",
        controller: "MainCtrl"
        
      .state "home.all",
        url: '/'
        templateUrl: "app/main/timeline.html",
        controller: "TimelineCtrl"

      .state "home.post",
        url: '/post/{post_id:[0-9]+}',
        templateUrl: 'app/main/post_detail.html',
        controller: 'PostDetailCtrl',

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

  .run ($rootScope, $window, $location, User) ->

    User.get_updates()

    $rootScope.$on '$stateChangeStart', () ->
      if User.is_auth
        if $location.path().match(/^\/signup/)
          $location.path('/')
        return
      if !$location.path().match(/^\/signup/)
        $window.location.href = '/signup'


#  .directive 'timeline', ()->
#    restrict: 'EA'
#    templateUrl: 'app/main/timeline.html',
#    scope: {
#      title: '@'
#      last_access_at: '=lastAccessAt'
#    }
#    controller: 'TimelineCtrl'

  .filter 'timeago', () ->
    (input) ->

      diff = parseInt((new Date)/1000) - input
      t = [
        ['秒前',   60],
        ['分前',   60],
        ['時間前', 24],
        ['日前',   null]
      ]

      str = ''
      angular.forEach t, (v) ->
        if str=='' && (v[1] == null || diff < v[1])
          str = diff + v[0]

        if v[1] != null
          diff = parseInt(diff / v[1])
      str

  .filter 'cindex', () ->
    (input) ->
      ("00" + input).substr(-3)
