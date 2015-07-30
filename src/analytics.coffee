module.exports = class Analytics
  constructor: ->
    @integrations = []

    for method in [
      'addedProduct'
      'completedOrder'
      'experimentViewed'
      'removedProduct'
      'viewedProduct'
      'viewedProductCategory'
    ]
      @[method] = =>
        @call method, arguments

  # Call method for each integration
  call: (method, args...) ->
    for integration in @integrations
      if integration[method]?
        integration[method].apply @, args

  initialize: (integrations = {}) ->
    for name, opts of integrations
      constructor = require './integrations/' + name
      integration = new constructor opts
      integration.init()
      integration.load()
      @integrations.push integration

  identify: (userId, traits, options, callback) ->
    @call 'identify', userId, traits, options, callback

  track: (event, properties, opts, cb) ->
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1

    if @method?
      @call method, properties, opts, cb
    else
      @call 'track', properties, opts, cb

  page: (category, name, properties, opts, cb) ->
    @call 'page', category, name, properties, opts, cb

  debug: (bool = true) ->
    @_debug = bool

  log: ->
    console?.log.apply @, arguments if @_debug

  # Un-implemented
  alias:       ->
  group:       ->
  load:        ->
  off:         ->
  on:          ->
  once:        ->
  ready:       ->
  reset:       ->
  trackClick:  ->
  trackForm:   ->
  trackLink:   ->
  trackSubmit: ->
  user:        ->
