export onload = (el, cb) ->
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

export tld = (domain) ->
  match = domain.match /[^.\s\/]+\.([a-z]{3,}|[a-z]{2}.[a-z]{2})$/
  if match?
    match[0]
  else
    domain

export safariPrivateBrowsing = ->
  try
    localStorage.t = 0
    false
  catch
    true

# http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/21963136#21963136
export uuid = ->
  lut = []
  for i in [0...256]
    lut[i] = (if i < 16 then '0' else '') + i.toString(16)

  do ->
    d0 = Math.random() * 0xffffffff | 0
    d1 = Math.random() * 0xffffffff | 0
    d2 = Math.random() * 0xffffffff | 0
    d3 = Math.random() * 0xffffffff | 0
    lut[d0 & 0xff] +
    lut[d0 >> 8 & 0xff] +
    lut[d0 >> 16 & 0xff] +
    lut[d0 >> 24 & 0xff] + '-' +
    lut[d1 & 0xff] +
    lut[d1 >> 8 & 0xff] + '-' +
    lut[d1 >> 16 & 0x0f | 0x40] +
    lut[d1 >> 24 & 0xff] + '-' +
    lut[d2 & 0x3f | 0x80] +
    lut[d2 >> 8 & 0xff] + '-' +
    lut[d2 >> 16 & 0xff] +
    lut[d2 >> 24 & 0xff] +
    lut[d3 & 0xff] +
    lut[d3 >> 8 & 0xff] +
    lut[d3 >> 16 & 0xff] +
    lut[d3 >> 24 & 0xff]

