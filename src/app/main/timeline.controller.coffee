angular.module "angularSample"
  .controller "Timeline", (Api, $scope,  $element, $attrs) ->
    console.log($scope)
    src_id   = $attrs.srcId
    src_type = $attrs.srcType

    console.log( "src_id: " + src_id + " src_type: " + src_type )

    $scope.posts = []
    
    Api.req('/post/get_timeline2',
      list_type: 1
      src_type: src_type
      src_id: src_id)
    .then (data) ->
      console.log(data)

      post_map = {}
      posts = []

      angular.forEach data.result.models.posts, (v) ->
        post_map[v.post_id] = v

      angular.forEach data.result.models.timelines, (v) ->
        posts.push post_map[v.post_id]

      $scope.posts = posts
      console.log($scope.posts)

