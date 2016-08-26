loadScript = require './loaders/script'
loadImg    = require './loaders/img'
loadIframe = require './loaders/iframe'

module.exports = class Integration
  init: ->

  load: (cb = ->) ->
    return unless @src? and @src.type? and @src.url?

    @log 'load', @src

    switch @src.type
      when 'script'
        loadScript @src, cb
      when 'img'
        loadImg @src, cb
      when 'iframe'
        loadIframe @src, cb
