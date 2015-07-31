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

  ready: (fn = ->) ->
    fn()
    @log 'ready'

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
      integration.log = =>
        @log.apply @, arguments

      @integrations.push integration

  identify: (userId, traits, opts, cb) ->
    @call 'identify', userId, traits, opts, cb

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
    console?.log.apply console, arguments if @_debug

  # Un-implemented
  alias:       ->
  group:       ->
  load:        ->
  off:         ->
  on:          ->
  once:        ->
  reset:       ->
  trackClick:  ->
  trackForm:   ->
  trackLink:   ->
  trackSubmit: ->
  user:        ->
