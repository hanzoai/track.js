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

  initialize: (opts = {}) ->
    @log 'initialize', opts
    opts.integrations ?= []

    for integration in opts.integrations
      Constructor = require './integrations/' + integration.type
      instance = new Constructor integration
      instance.init()
      instance.load()
      @integrations.push instance
    @

  # Call method for each integration
  call: (event, props, cb) ->
    @log 'call', event, props
    method = methodName event
    for integration in @integrations
      if integration[method]?
        integration.log method, props
        integration[method].call integration, event, props, cb
      else
        if integration.track?
          integration.log 'track', event, props
          integration.track.call integration, event, props, cb
    @

  identify: (userId, props, cb) ->
    [props, cb] = normalizeCall props, cb
    props.userId ?= userId
    @log 'identify', props
    @call 'identify', props, cb

  track: (event, props, cb) ->
    [props, cb] = normalizeCall props, cb
    @log 'track', event, props
    @call event, props, cb

  page: (category, name, props, cb) ->
    [props, cb] = normalizeCall props, cb
    if typeof category is 'string'
      props.category = category
    if typeof name is 'string'
      props.name = name
    @log 'page', props
    @call 'page', props, cb

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
