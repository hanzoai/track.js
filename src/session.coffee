safariPrivateBrowsing = ->
  try
    localStorage.t = 0
    false
  catch
    true

cookies = ->
  cookies = (require 'cookies-js') window
  domain  = (document.domain.match /[^.\s\/]+\.([a-z]{3,}|[a-z]{2}.[a-z]{2})$/)[0]
  key     = '_hza'

  state = ->
    value = cookies.get key
    if value?
      JSON.parse value
    else
      {}

  get: (k) ->
    state()[k]

  set: (k, v) ->
    s = state()
    s[k] = v
    cookies.set key, JSON.stringify s,
      domain:  domain
      secure:  true
      expires: Infinity

  remove: (k) ->
    @set k, undefined

  clear: ->
    cookies.expire key

module.exports = if safariPrivateBrowsing() then cookies() else require 'store'
