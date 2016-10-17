session = require './session'
{uuid}  = require './utils'

class Identity
  constructor: ->
    props = (session.get 'identity') ? {}
    for k,v of props
      @[k] = v
    unless @userId? or @anonId?
      @anonId = uuid()

  set: (k, v) ->
    traits = identity()
    traits[k] = v
    session.set 'identity', traits

  clear: ->
    session.remove 'identity'

  id: ->
    @userId ? @anonId

module.exports = new Identity
