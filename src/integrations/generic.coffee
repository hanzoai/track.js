Integration = require '../integration'

module.exports = class Generic extends Integration
  constructor: (@opts) ->
    @src ?= @opts.src

  init: ->
    return if window._fbq?
    window._fbq = []

  page: (category, name, props, opts, cb) ->
    name = category if arguments.length == 1
    @track name, props, opts, cb

  track: (event, props, opts, cb = ->) ->
    return unless event == @opts.event

    @log 'Generic.track', @opts.name, event, props, opts

    @opts.fn event, props, opts, cb
