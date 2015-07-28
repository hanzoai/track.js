loadScript = require './loaders/script'
loadImg    = require './loaders/img'
loadIframe = require './loaders/iframe'

module.exports = class Integration
  load: (cb) ->
    switch @type
      when 'script'
        loadScript @opts, cb
      when 'img'
        loadImg @opts, cb
      when 'iframe'
        loadIframe @opts, cb
