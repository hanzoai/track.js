{onload} = require '../utils'

module.exports = (opts, cb=->) ->
  script = document.createElement 'script'
  onload script, cb

  script.type = opts.type or 'text/javascript'
  script.charset = opts.charset or 'utf8'
  script.async = (if 'async' of opts then !!opts.async else true)
  script.src = opts.src

  for k,v of attrs
    script.setAttribute k, v

  script.text = '' + opts.text if opts.text

  head = document.head or document.getElementsByTagName('head')[0]
  head.appendChild script

  script
