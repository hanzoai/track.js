Integration = require '../integration'

module.exports = class FacebookConversions extends Integration
  type: 'script'
  src:  '//connect.facebook.net/en_US/fbds.js';

  constructor: (@pixels = {}) ->

  init: ->
    return if window._fbq?
    window._fbq = []

  load: ->
    super
    _fbq.loaded = true

  page: (category, name, props, opts, cb) ->
    name = category if arguments.length == 1
    @track name, props, opts, cb

  track: (event, props, opts, cb = ->) ->
    return unless (pixel = @pixels[event])?

    @log 'FacebookConversions.track', arguments

    id       = pixel.id
    value    = props.value    ? pixel.value    ? '0.00'
    currency = props.currency ? pixel.currency ? 'USD'

    _fbq.push ['track', id, value: value, currency: currency]
