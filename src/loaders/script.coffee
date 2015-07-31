{onload} = require '../utils'

module.exports = (opts, cb) ->
  script = document.createElement 'script'
  onload script, cb

  script.async = opts.async ? 1
  script.src = opts.src

  for k,v of opts.attrs
    script.setAttribute k, v

  script.text = '' + opts.text if opts.text

  head = document.head or document.getElementsByTagName('head')[0]
  head.parentNode.insertBefore script, head

  script
