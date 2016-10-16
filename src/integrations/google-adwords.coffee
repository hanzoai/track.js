Integration = require '../integration'

module.exports = class GoogleAdWords extends Integration
  src:
    type: 'script'
    url: '//www.googleadservices.com/pagead/conversion_async.js'

  constructor: (@opts) ->
    @queue = []

  init: ->
    return if window.google_trackConversion?

    window.google_trackConversion = (event) =>
      @queue.push event

  load: (cb) ->
    super =>
      # replay event to clear queue
      if @queue.length
        google_trackConversion event for event in @queue
      cb null

  page: (category, name, props, cb) ->
    name = category if arguments.length == 1

    return unless name == @opts.event

    google_trackConversion
      google_conversion_id:    @opts.id
      google_custom_params:    props
      google_remarketing_only: true

    cb null

  track: (event, props, cb) ->
    return unless event == @opts.event

    google_trackConversion
      google_conversion_id:       @opts.id
      google_custom_params:       props
      google_conversion_language: 'en'
      google_conversion_format:   '3'
      google_conversion_color:    'ffffff'
      google_conversion_label:    event
      google_conversion_value:    props.total
      google_remarketing_only:    false

    cb null
