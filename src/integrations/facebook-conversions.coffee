Integration = require '../integration'

module.exports = class FacebookConversions extends Integration
  type: 'script'
  src:  '//connect.facebook.net/en_US/fbds.js';

  constructor: (opts) ->
    for k,v of opts
      @[k] = v

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
    return unless event == @event

    @log 'FacebookConversions.track', arguments

    id       = @id
    value    = props.value    ? @value    ? '0.00'
    currency = props.currency ? @currency ? 'USD'

    _fbq.push ['track', id, value: value, currency: currency]
