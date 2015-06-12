Hapi = require 'hapi'
Q    = require 'q'

getTenant = (req) ->
  deferred = Q.defer()

  deferred.resolve('foo') if req.info.referrer
  deferred.resolve('bar') if !req.info.referrer

  deferred.promise

Routes =[
  {
    method: 'GET'
    path:   '/'
    handler: (request, reply) ->
      getTenant(request).then (tenant) ->
        console.log 'tenant', tenant

        # here `User` is not defined and doesn't even exist
        # why is there no error here?

        if !User.isAuthorized(request, tenant)
          reply 'not authorized'
        else
          reply 'authorized' 
    
  }
]

server = new Hapi.Server()

opts =
  port    : 8000
  address : '0.0.0.0'

server.connection opts

server.route(Routes)

server.start ->
  console.log 'server started....', server.info.uri