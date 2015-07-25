module.exports = class Facebook
  constructor: (@opts) ->

  init: ->
    do (f = window, b = document, e = 'script', v = '//connect.facebook.net/en_US/fbevents.js', n, t, s) ->
      return if f.fbq

      n = f.fbq = ->
        (if n.callMethod then n.callMethod.apply(n, arguments) else n.queue.push(arguments))
        return

      f._fbq = n unless f._fbq
      n.push = n
      n.loaded = not 0
      n.version = '2.0'
      n.queue = []
      t = b.createElement(e)
      t.async = not 0
      t.src = v
      s = b.getElementsByTagName(e)[0]
      s.parentNode.insertBefore t, s
      return

    fbq 'init', @remarketingId

  page: (category, name, properties, opts, callback) ->
    fbq 'track', 'PageView'
