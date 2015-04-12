angular.module "angularSample"
  .factory 'Api', ($q, $http) ->
    Api =
      req: (uri, params) ->
        _params =
          build: "20300002"
          params: params

        deferred = $q.defer()
        $http.post('/api' + uri, _params)
          .success (data, status, headers, config) ->
            deferred.resolve(data)
          .error (data, status, headers, config) ->
            console.log(data)
            deferred.reject(data)

        deferred.promise
