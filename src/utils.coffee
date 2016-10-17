exports.onload = (el, cb) ->
  add = (el, cb) ->
    el.addEventListener 'load', (_, e) ->
      cb null, e
    , false
    el.addEventListener 'error', (e) ->
      err = new Error "failed to load the script '#{el.src}'"
      err.event = e
      cb err
    , false

  attach = (el, cb) ->
    el.attachEvent 'onreadystatechange', (e) ->
      return  unless /complete|loaded/.test(el.readyState)
      cb null, e
    el.attachEvent 'onerror', (e) ->
      err = new Error "failed to load the script '#{el.src}'"
      err.event = e or window.event
      cb err

  if el.addEventListener
    add el, cb
  else
    attach el, cb

exports.tld = (domain) ->
  (domain.match /[^.\s\/]+\.([a-z]{3,}|[a-z]{2}.[a-z]{2})$/)[0]

exports.safariPrivateBrowsing = ->
  try
    localStorage.t = 0
    false
  catch
    true
