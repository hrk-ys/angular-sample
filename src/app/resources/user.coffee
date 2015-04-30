angular.module "angularSample"
  .factory 'User', (storage, Api) ->
    User =
      is_auth: false
      user_id: ""
      email: ""

      company: null
      domain: null

      server_settings: null

      load: ()->
        console.log('user load')
        this.is_auth = storage.get('is_auth')
        this.user_id = storage.get('user_id')
        this.email   = storage.get('email')
        this.company = storage.get('company')
        this.domain  = storage.get('domain')
        this.service_setting  = storage.get('service_setting')

      save: ()->
        console.log('user save')
        storage.set('is_auth', this.is_auth)
        storage.set('user_id', this.user_id)
        storage.set('email', this.email)
        storage.set('company', this.company)
        storage.set('domain', this.domain)
        storage.set('service_setting', this.service_setting)

      get_updates: () ->
        self = this
        Api.req('/account/get_updates', {})
          .then (data) ->
            console.log(data)
            self.service_setting =
              'lounges': data.result.updates.service_setting.lounges
            self.save()
            

      # メール登録
      signup: (email) ->
        console.log('tapped signup')
        self = this
        this.email = {email: email}
        
        Api.req '/account/signup',
          email: email
        .then (data) ->
          console.log( data )
          self.user_id = data.result.user_id
          self.email   = data.result.email
          self.save()

      # メール認証
      email_auth: (pin) ->
        console.log('user email_auth: ' + pin)
        self = this

        Api.req '/account/email_auth_pin',
          pin: pin
        .then (data) ->
          console.log( data )
          self.company = data.result.company
          self.domain  = data.result.domain
          self.email   = data.result.email
          self.is_auth = true
          self.save()

      logout: () ->
        storage.clearAll()

    User.load()
    User

       
