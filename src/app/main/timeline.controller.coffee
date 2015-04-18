angular.module "angularSample"
  .controller "TimelineCtrl", (Api, $scope, Timelines) ->

    SHOW_COMMENT_NUM = 3

    timelines = Timelines

    $scope.posts = []
    $scope.cursor = 0
    $scope.timelines = timelines

    sync_posts = () ->
      $scope.posts.length = 0
      angular.forEach timelines, (v) ->
        angular.forEach v.posts, (vp) ->
          $scope.posts.push vp

    angular.forEach timelines, (v) ->
      console.log(v)
      v.load_content().then( () ->
        sync_posts()
      )

    sync_posts()
      
    resolveTimeline = (post) ->
      timeline = null
      console.log(post.src_id)
      console.log(post.src_type)
      angular.forEach timelines, (v) ->
        console.log(v.src_id)
        console.log(v.src_type)
        if post.src_id == v.src_id && post.src_type == v.src_type
          timeline = v
      console.log(timeline)
      return timeline


    $scope.$on 'PostUpdated', () ->
      console.log("post_callback")
      sync_posts()

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
        console.log(p)
        sync_posts()

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

        timeline = resolveTimeline(post)
        i = 0
        index = -1
        angular.forEach timeline.posts, (v) ->
          if index == -1
            if v.post_id == post.post_id
              index = i
            i++
        timeline.posts.splice(i, 1)
        sync_posts()

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




