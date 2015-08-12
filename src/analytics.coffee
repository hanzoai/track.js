Integration = require './integration'

module.exports = class Analytics
  constructor: ->
    @integrations = []

    Integration::log = =>
      @log.apply @, arguments

  ready: (fn = ->) ->
    @log 'Analytics.ready'
    fn()

  initialize: (opts = {}) ->
    @log 'Analytics.initialize', opts
    opts.integrations ?= []

    for integration in opts.integrations
      constructor = require './integrations/' + integration.type
      instance = new constructor integration
      instance.init()
      instance.load()
      @integrations.push instance

  # Call method for each integration
  call: (method, event, props, opts, cb = ->) ->
    @log 'Analytics.call', method, event, props, opts
    for integration in @integrations
      if integration[method]?
        integration[method].call integration, event, props, opts, cb
      else
        integration.track.call integration, event, props, opts, cb

  identify: (userId, traits, opts, cb) ->
    @log 'Analytics.identify', arguments
    @call 'identify', userId, traits, opts, cb

  track: (event, props, opts, cb) ->
    @log 'Analytics.track', event, props, opts
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1
    @call method, event, props, opts, cb

  page: (category, name, props, opts, cb) ->
    @log 'Analytics.page', arguments
    @call 'page', category, name, props, opts, cb

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
