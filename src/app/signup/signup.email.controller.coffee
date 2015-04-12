angular.module "angularSample"
  .controller "SignupEmail", ($scope, $location, User) ->
    $scope.email = 'ta@t9.a.a' # User.email
    $scope.submit = ()->
      console.log("input email: " + $scope.email)
      User.signup($scope.email)
        .then () ->
          console.log('signup ok?')
          $location.path('/signup/pin')

  .controller "SignupPin", ($scope, $location, User) ->
    $scope.submit = () ->
      User.email_auth($scope.pin)
        .then (data) ->
          $location.path('/')

