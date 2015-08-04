Integration = require '../integration'

module.exports = class GoogleAdWords extends Integration
  type: 'script'
  src: '//www.googleadservices.com/pagead/conversion_async.js'

  constructor: (opts) ->
    for k,v of opts
      @[k] = v
    @queue = []

  init: ->
    return if window.google_trackConversion?

    window.google_trackConversion = (event) =>
      @queue.push event

  load: (cb = ->) ->
    super =>
      # replay event to clear queue
      if @queue.length
        @log 'GoogleAdWords.load', 'replaying events:', @queue
        google_trackConversion event for event in @queue
      cb null

  page: (category, name, props, opts, cb = ->) ->
    name = category if arguments.length == 1

    return unless name == @event

    @log 'GoogleAdWords.page', arguments

    google_trackConversion
      google_conversion_id:    @id
      google_custom_params:    props
      google_remarketing_only: true

    cb null

  track: (event, props, opts, cb = ->) ->
    return unless event == @event

    @log 'GoogleAdWords.track', arguments

    google_trackConversion
      google_conversion_id:       @id
      google_custom_params:       props
      google_conversion_language: 'en'
      google_conversion_format:   '3'
      google_conversion_color:    'ffffff'
      google_conversion_label:    event
      google_conversion_value:    props.total
      google_remarketing_only:    false

    cb null
