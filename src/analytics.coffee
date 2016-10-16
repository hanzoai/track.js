Integration = require './integration'

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

  ready: (fn = ->) ->
    @log 'ready'
    fn()

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
  call: (method, event, props, cb = ->) ->
    @log 'call', method, event, props
    for integration in @integrations
      if integration[method]?
        integration.log method, event, props
        integration[method].call integration, event, props, cb
      else
        integration.log (event ? method), props
        integration.track.call integration, (event ? method), props, cb
    @

  identify: (userId, props, cb = ->) ->
    @log 'identify', userId, props
    @call 'identify', userId, props, cb

  track: (event, props, cb = ->) ->
    @log 'track', event, props
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1
    @call method, event, props, cb

  page: (category, name, props, cb = ->) ->
    @log 'page', category, name, props
    @call 'page', category, name, props, cb

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
