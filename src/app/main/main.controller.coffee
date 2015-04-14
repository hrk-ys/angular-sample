angular.module "angularSample"
  .controller "MainCtrl", (storage, $scope) ->
    $scope.timelines = [
      { src_type: 1, src_id: 0 },
      { src_type: 2, src_id: 200001 },
      { src_type: 3, src_id: 200002 },
      { src_type: 4, src_id: 200003 },
    ]
    $scope.last_access_at = storage.get('last_access_at')
    storage.set('last_access_at', parseInt((new Date)/1000))

