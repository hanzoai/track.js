session = require './session'
{uuid}  = require './utils'

identity = ->
  traits = (session.get 'identity') ? {}
  unless traits.userId?
    traits.userId = uuid()
  traits

identity.set = (k, v) ->
  traits = identity()
  traits[k] = v
  session.set 'identity', traits

identity.clear = ->
  session.remove 'identity'

module.exports = identity
