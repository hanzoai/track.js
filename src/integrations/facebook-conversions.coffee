Integration = require '../integration'

module.exports = class FacebookConversions extends Integration
  type: 'script'
  src:  '//connect.facebook.net/en_US/fbds.js';

  constructor: (@opts) ->

  init: ->
    return if window._fbq?
    window._fbq = []

  load: ->
    return if _fbq?.loaded
    super
    _fbq.loaded = true

  page: (category, name, props, opts, cb) ->
    name = category if arguments.length == 1
    @track name, props, opts, cb

  track: (event, props, opts, cb = ->) ->
    return unless event == @opts.event

    @log 'FacebookConversions.track', arguments

    id       = @opts.id
    value    = props.value    ? @opts.value    ? '0.00'
    currency = props.currency ? @opts.currency ? 'USD'

    _fbq.push ['track', id, value: value, currency: currency]
