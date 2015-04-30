angular.module "angularSample"
  .controller "MainCtrl", (storage, $window, $location, $scope, User, Timelines) ->

    console.log('main ctrl')
    $scope.last_access_at = storage.get('last_access_at')
    storage.set('last_access_at', parseInt((new Date)/1000))

    $scope.timelines = Timelines

    $scope.reload = () ->
      if $location.path() == '/'
        $window.location.reload()

    $scope.logout = () ->
      User.logout()
      $window.location.reload()

