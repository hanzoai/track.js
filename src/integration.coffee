loadScript = require './loaders/script'
loadImg    = require './loaders/img'
loadIframe = require './loaders/iframe'

module.exports = class Integration
  init: ->
    @log 'Integration.init'

  load: (cb = ->) ->
    @log 'Integration.load', @src

    return unless @src?.type? and @src?.url?

    switch @src.type
      when 'script'
        loadScript @src.url, cb
      when 'img'
        loadImg @src.url, cb
      when 'iframe'
        loadIframe @src.url, cb
