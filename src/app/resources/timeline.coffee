angular.module "angularSample"
  .factory 'Timelines', (Timeline, User) ->
    timelines = []
    timelines.push new Timeline('ルーム', User.company.company_id, 1)
    angular.forEach User.service_setting.lounges, (v) ->
      timelines.push new Timeline(v.name, v.lounge_id, 2)
    timelines

  .service 'Timeline', (storage, Api) ->
    class Timeline
      constructor: (title, src_id, src_type) ->
        @posts  = []
        @title = title
        @src_id = src_id
        @src_type = src_type
        @cursor   = 0
        @has_more = false

      SHOW_COMMENT_NUM = 3

      setup_post: (post) ->
        post.timeline = this
        post.comments = []

      load_content: () ->
        console.log('get_timeline2')
        self = this
        Api.req('/post/get_timeline2',
          list_type: 3
          src_type: @src_type
          src_id: @src_id
          cursor:
            before: @cursor
        ).then (data) ->
    
          post_map = {}
    
          self.has_more = data.result.models.posts.length == 20
          angular.forEach data.result.models.posts, (v) ->
            if v.status == "1"
              post_map[v.post_id] = v
              self.setup_post(v)
              v.show_comment_num = SHOW_COMMENT_NUM
    
          console.log(data)
          angular.forEach data.result.models.post_comments, (v) ->
            if v.status == "1"
              post_map[v.post_id].comments.push v
    
          angular.forEach data.result.models.timelines, (v) ->
            if v.status == "1"
              p = post_map[v.post_id]
              p.sort_value = v.sort_value
              self.posts.push p
              self.cursor = v.sort_value if self.cursor == 0 || self.cursor > v.sort_value

