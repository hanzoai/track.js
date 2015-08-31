{onload} = require '../utils'

module.exports = (opts, cb) ->
  iframe = document.createElement 'iframe'
  onload iframe, cb

  iframe.width = 1
  iframe.height = 1
  iframe.style.display = 'none'
  iframe.src = opts.url

  first = (document.getElementsByTagName 'script')[0]
  first.parentNode.insertBefore iframe, first

  iframe
