import Integration from '../integration'

class FacebookConversions extends Integration
  src:
    type: 'script'
    url: '//connect.facebook.net/en_US/fbds.js';

  constructor: (@opts) ->

  init: ->
    return if window._fbq?
    window._fbq = []

  load: ->
    return if _fbq?.loaded
    super
    _fbq.loaded = true

  page: (category, name, props, cb) ->
    name = category if arguments.length == 1
    @track name, props, cb

  track: (event, props, cb) ->
    return unless event == @opts.event

    id       = @opts.id
    value    = props.value    ? @opts.value    ? '0.00'
    currency = props.currency ? @opts.currency ? 'USD'

    _fbq.push ['track', id, value: value, currency: currency]

export default FacebookConversions
