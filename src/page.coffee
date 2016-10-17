session = require './session'
{tld}   = require './utils'

module.exports =
  title: -> document.title

  referrer: ->
    return @_referrer if @_referrer?
    domain = tld document.domain
    ref = document.referrer
    if (ref.indexOf domain) == -1
      session.set 'referrer', ref
      @_referrer = ref
    else
      @_referrer = (session.get 'referrer') ? ''
