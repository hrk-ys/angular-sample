angular.module "angularSample"
  .controller "SignupEmail", ($scope, $location, User) ->
    if User.email == null
      $scope.email = ""
    else
      $scope.email = User.email.email
    $scope.submit = ()->
      console.log("input email: " + $scope.email)
      User.signup($scope.email)
        .then () ->
          $location.path('/signup/pin')

  .controller "SignupPin", ($scope, $location, User) ->
    $scope.submit = () ->
      User.email_auth($scope.pin)
        .then (data) ->
          $location.path('/')

