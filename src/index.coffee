module.exports = class Analytics
  constructor: ->
    @integrations = []

    for method in [
      'viewedProductCategory'
      'viewedProduct'
      'addedProduct'
      'removedProduct'
      'completedOrder'
      'experimentViewed'
    ]
      @[method] = =>
        @call method, arguments

  # Call method for each integration
  call: (method, args...) ->
    for integration in @integrations
      if integration[method]?
        integration[method].apply @, args

  addIntegration: (name, opts = {}) ->
    switch name
      when 'Google Analytics'
        @integrations.push new Google opts
      when 'Facebook Conversion Tracking'
        @integrations.push new Facebook opts

  initialize: (integrations = {}) ->
    for k,v of integrations
      @addIntegration k, v

  identify: (userId, traits, options, callback) ->
    @call 'identify', userId, traits, options, callback

  track: (event, properties, options, callback) ->
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1

    if @method?
      @call method, properties, options, callback
    else
      @call 'track', properties, options, callback

  page: (category, name, properties, options, callback) ->
    @call 'page', category, name, properties, options, callback

  debug: (bool = true) ->
    @_debug = bool

  log: ->
    console?.log.apply @, arguments if @_debug

  # Un-implemented
  alias: (userId, previousId, options, callback) ->
  reset: ->
  ready: ->
  user: ->
  group: ->
  load: ->
  on: (event, cb) ->
    # cb expects `function(event, properties, options)`
