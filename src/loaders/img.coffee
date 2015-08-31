{onload} = require '../utils'

module.exports = (opts, cb) ->
  img = new Image()
  onload img, cb

  img.width = 1
  img.height = 1
  img.src = opts.url

  img
