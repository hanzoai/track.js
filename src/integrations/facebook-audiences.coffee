Integration = require '../integration'

module.exports = class FacebookAudiences extends Integration
  type: 'script'
  src:  '//connect.facebook.net/en_US/fbevents.js'

  constructor: (@opts) ->

  init: ->
    return if window.fbq?

    fbq = window.fbq = ->
      if fbq.callMethod
        fbq.callMethod.apply fbq, arguments
      else
        fbq.queue.push arguments
      return

    window._fbq = fbq unless window._fbq
    fbq.push = fbq
    fbq.loaded = not 0
    fbq.version = '2.0'
    fbq.queue = []

    fbq 'init', @opts.id
    fbq 'track', 'PageView'

  page: (category, name, props = {}, opts = {}, cb = ->) ->
    @log 'FacebookAudiences.page', arguments
    fbq 'track', 'ViewContent'
    cb null

  track: (event, props, opts, cb = ->) ->
    switch event
      when 'Initiate Checkout'
        fbq 'track', 'InitiateCheckout'
      when 'Add Payment Info'
        fbq 'track', 'AddPaymentInfo'
      when 'Lead'
        fbq 'track', 'Lead'
      when 'Complete Registration'
        fbq 'track', 'CompleteRegistration'
      when 'Search'
        fbq 'track', 'Search'
      when 'Add to Wishlist'
        fbq 'track', 'AddToWishList'
    cb null

  viewedProduct: (event, props, opts, cb = ->) ->
    @log 'FacebookAudiences.viewedProduct', arguments
    fbq 'track', 'ViewContent'
    cb null

  addedProduct: (event, props, opts, cb = ->) ->
    @log 'FacebookAudiences.addedProduct', arguments
    fbq 'track', 'AddToCart'
    cb null

  completedOrder: (event, props, opts, cb = ->) ->
    @log 'FacebookAudiences.completedOrder', arguments
    fbq 'track', 'Purchase',
      value:    props.total
      currency: props.currency ? 'USD'
    cb null
