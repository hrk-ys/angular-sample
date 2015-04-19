angular.module "angularSample"
  .directive 'postForm', ($parse, $modal)->
    restrict: 'EA'
    templateUrl: 'app/main/post_form.html',
    link: (scope, element, attrs, ctrl) ->
      console.log('postForm link start')
    
      scope.open_post_form = () ->
        console.log('open_post')
        modalInstance = $modal.open(
          templateUrl: 'myModalContent.html',
          controller: 'PostFormCtrl'
        )

        modalInstance.result.then( (post) ->
          console.log('postForm result')
          scope.$broadcast('PostUpdated', post)
          console.log('PostUpdated broadcast!!')
        , () ->
          console.log("cancel")
        )
      console.log('postForm link end')

  .controller 'PostFormCtrl', ($scope, $modalInstance, Api, Timelines) ->
    console.log("post form ctrl")
    $scope.timelines = Timelines
    $scope.selected = $scope.timelines[0]

    $scope.post = (timeline) ->
      Api.req('/post/post',
        src_id: timeline.src_id
        src_type: timeline.src_type
        caption: $scope.content
        icon_id: Math.ceil(Math.random()*34 + 1)
        icon_color: Math.ceil(Math.random()*4 + 1)
      ).then (data) ->
        console.log(data)
        $scope.content = ""
        p = data.result.models.post
        timeline.setup_post(p)
        
        p.sort_value = data.result.models.timelines[0].sort_value
        timeline.posts.push p
        $modalInstance.close(p)

    $scope.cancel = () ->
      $modalInstance.dismiss('cancel')

