{safariPrivateBrowsing, tld} = require './utils'
{document, window} = require './browser'

# Default session storage
localStorage = -> require 'store'

# Fallback to cookie storage to handle safari private browsing mode
cookies = ->
  cookies = (require 'cookies-js') window
  domain  = tld document.domain
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

module.exports = if safariPrivateBrowsing() then cookies() else localStorage()
