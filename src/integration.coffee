loadIframe = require './loaders/iframe'
loadImg    = require './loaders/img'
loadScript = require './loaders/script'
sample     = require './sample'

module.exports = class Integration
  init: ->

  name: -> @opts.type

  sample: ->
    # If sampling is defined, use that to control whether that integration does anything or not
    if @opts.sample?
      return sample @name(), @opts.sample
    true

  load: (cb = ->) ->
    return unless @src? and @src.type? and @src.url?

    @log 'load', @src

    switch @src.type
      when 'script'
        switch typeof @src.url
          when 'object'
            if window.location.protocol == 'https:'
              @src.url = @src.url.https
            else
              @src.url = @src.url.http
          when 'function'
            @src.url = @src.url.call @
        loadScript @src, cb
      when 'img'
        loadImg @src, cb
      when 'iframe'
        loadIframe @src, cb
