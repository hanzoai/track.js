loadScript = require './loaders/script'
loadImg    = require './loaders/img'
loadIframe = require './loaders/iframe'

module.exports = class Integration
  init: ->
    @log 'Integration.init'

  load: (cb = ->) ->
    @log 'Integration.load', @type
    switch @type
      when 'script'
        loadScript @, cb
      when 'img'
        loadImg @, cb
      when 'iframe'
        loadIframe @, cb
