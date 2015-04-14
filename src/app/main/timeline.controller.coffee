angular.module "angularSample"
  .controller "Timeline", (Api, $scope,  $element, $attrs) ->
    src_id   = $attrs.srcId
    src_type = $attrs.srcType

    SHOW_COMMENT_NUM = 3
    console.log( "src_id: " + src_id + " src_type: " + src_type )

    $scope.posts = []
    $scope.cursor = 0
    console.log($scope.last_access_at)


    $scope.post = () ->
      Api.req('/post/post',
        src_id: src_id
        src_type: src_type
        caption: $scope.content
        icon_id: Math.ceil(Math.random()*34 + 1)
        icon_color: Math.ceil(Math.random()*4 + 1)
      ).then (data) ->
        console.log(data)
        $scope.content = ""
        p = data.result.models.post
        p.comments = []
        p.sort_value = data.result.models.timelines[0].sort_value
        $scope.posts.push p

    $scope.reply = (post) ->
      Api.req('/post/add_comment',
        post_id: post.post_id
        content: post.reply_comment
        icon_id: Math.ceil(Math.random()*33 + 1)
        icon_color: Math.ceil(Math.random()*3 + 1)
      ).then (data) ->
        console.log(data)
        post.reply_comment=''
        post.comments.push data.result.models.post_comment

    $scope.add_show_comment_num = (post) ->
      post.show_comment_num=post.show_comment_num+3

    $scope.delete = (post) ->
      Api.req('/post/delete_post',
        post_id: post.post_id
      ).then (data) ->
        console.log(data)

        i = 0
        angular.forEach $scope.posts, (v) ->
          if v.post_id == post.post_id
            return
          i++
        $scope.posts.splice(i, 1)

    $scope.delete_comment = (post, comment) ->
      Api.req('/post/delete_comment',
        post_comment_id: comment.post_comment_id
      ).then (data) ->
        console.log(data)

        i = 0
        angular.forEach post.comments, (v) ->
          if v.post_comment_id == comment.post_comment_id
            return
          i++
        post.comments.splice(i, 1)



    $scope.load_content = () ->
      
      Api.req('/post/get_timeline2',
        list_type: 3
        src_type: src_type
        src_id: src_id
        cursor:
          before: $scope.cursor)
      .then (data) ->
  
        post_map = {}
  
        $scope.has_more = data.result.models.posts.length == 20
        angular.forEach data.result.models.posts, (v) ->
          if v.status == "1"
            post_map[v.post_id] = v
            v.comments = []
            v.show_comment_num = SHOW_COMMENT_NUM
  
        console.log(data)
        angular.forEach data.result.models.post_comments, (v) ->
          if v.status == "1"
            post_map[v.post_id].comments.push v
  
        angular.forEach data.result.models.timelines, (v) ->
          if v.status == "1"
            p = post_map[v.post_id]
            p.sort_value = v.sort_value
            $scope.posts.push p
            $scope.cursor = v.sort_value if $scope.cursor == 0 || $scope.cursor > v.sort_value
  
    $scope.load_content()
