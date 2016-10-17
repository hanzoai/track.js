Integration = require './integration'

methodName = (event) ->
  name = event.replace /\s+/g, ''
  name[0].toLowerCase() + name.substring 1

normalizeCall = (props = {}, cb = ->) ->
  if typeof props is 'function'
    [props, cb] = [{}, cb]
  [props, cb]

module.exports = class Analytics
  constructor: ->
    @integrations = []

    # Easily flip on debug
    if typeof location != 'undefined'
      @_debug = location.search.indexOf('v=1') != -1

    # Selectively bind this so that log method knows which constructor it's
    # logging for
    _this = @
    Integration::log = ->
      args = Array::slice.call arguments
      args.unshift @constructor.name
      _this.log.apply _this, args

  debug: (bool = true) ->
    @_debug = bool

  log: ->
    console?.log.apply console, arguments if @_debug

  ready: (cb = ->) ->
    @log 'ready'
    cb()

  initialize: ({integrations = []}) ->
    @log 'initialize', integrations
    for opts in integrations
      do (opts) =>
        Constructor = require './integrations/' + opts.type
        integration = new Constructor opts
        integration.init()
        integration.load()
        @integrations.push integration
    return

  # Call method for each integration
  call: (event, args...) ->
    @log 'call', event, args...

    method = methodName event

    for integration in @integrations
      if integration[method]?
        integration.log method, args...
        integration[method].call integration, args...
      else
        if integration.track?
          integration.log 'track', event, args...
          integration.track.call integration, event, args...
    return

  identify: (userId, props, cb) ->
    [props, cb] = normalizeCall props, cb
    props.userId ?= userId
    @log 'identify', props
    @call 'identify', userId, props, cb
    return

  track: (event, props, cb) ->
    [props, cb] = normalizeCall props, cb
    @log 'track', event, props
    @call 'track', event, props, cb
    return

  page: (category, name, props, cb) ->
    [props, cb] = normalizeCall props, cb
    if typeof category is 'string'
      props.category = category
    if typeof name is 'string'
      props.name = name
    @log 'page', props
    @call 'page', category, name, props, cb
    return

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
