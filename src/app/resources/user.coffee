angular.module "angularSample"
  .factory 'User', (storage, Api) ->
    User =
      is_auth: false
      user_id: ""
      email: ""

      company: null
      domain: null

      load: ()->
        console.log('user load')
        this.is_auth = storage.get('is_auth')
        this.user_id = storage.get('user_id')
        this.email   = storage.get('email')
        this.company = storage.get('company')
        this.domain  = storage.get('domain')
        console.log( this )

      save: ()->
        console.log('user save')
        storage.set('is_auth', this.is_auth)
        storage.set('user_id', this.user_id)
        storage.set('email', this.email)
        storage.set('company', this.company)
        storage.set('domain', this.domain)

      # メール登録
      signup: (email) ->
        console.log('tapped signup')
        self = this
        
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

    User.load()
    User

       
