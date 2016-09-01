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
  call: (method, event, props, opts, cb = ->) ->
    @log 'call', method, event, props, opts
    for integration in @integrations
      if integration[method]?
        integration.log method, event, props, opts
        integration[method].call integration, event, props, opts, cb
      else
        integration.log event, props, opts
        integration.track.call integration, event, props, opts, cb
    @

  identify: (userId, traits, opts, cb) ->
    @log 'identify', userId, traits, opts
    @call 'identify', userId, traits, opts, cb

  track: (event, props, opts, cb) ->
    @log 'track', event, props, opts
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1
    @call method, event, props, opts, cb

  page: (category, name, props, opts, cb) ->
    @log 'page', category, name, props, opts
    @call 'page', category, name, props, opts, cb

  debug: (bool=true) ->
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
