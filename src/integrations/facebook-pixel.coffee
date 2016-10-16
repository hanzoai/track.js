Integration = require '../integration'

parseCurrency = (value) ->
  if typeof value == 'string'
    value
  else if typeof value == 'number'
    value.toFixed 2

module.exports = class FacebookPixel extends Integration
  src:
    type: 'script'
    url: '//connect.facebook.net/en_US/fbevents.js'

  constructor: (@opts) ->
    @opts.values ?= {}
    @opts.values.viewedProduct ?=
      percent: 0.0001
      currency: 'USD'

    @opts.values.addedProduct ?=
      percent: 0.001
      currency: 'USD'

    @opts.values.initiateCheckout ?=
      percent: 0.01
      currency: 'USD'

    @opts.values.addPaymentInfo ?=
      percent: 0.02
      currency: 'USD'

  init: ->
    return if window.fbq?

    fbq = ->
      if fbq.callMethod
        fbq.callMethod.apply fbq, arguments
      else
        fbq.queue.push arguments
      return

    fbq.push    = fbq
    fbq.loaded  = true
    fbq.version = '2.0'
    fbq.queue   = []
    fbq.agent   = 'hanzo'
    # fbq.disablePushState = true # disable automatic page tracking

    window.fbq = window._fbq = fbq

    if @identity?
      fbq 'init', @opts.id, @identity
    else
      fbq 'init', @opts.id
    return

  identify: (userId, props, opts, cb = ->) ->
    @identity =
      em: props.email
      ph: props.phone
      fn: props.firstName
    cb null

  page: (category, name, props = {}, opts = {}, cb = ->) ->
    # fbq 'track', 'PageView'
    # Nothing to do as FB tracks this automatically
    cb null

  track: (event, props, opts, cb = ->) ->
    switch event
      when 'Lead'
        fbq 'track', 'Lead'
      when 'Complete Registration'
        fbq 'track', 'CompleteRegistration'
          # status: ''
      when 'Search'
        fbq 'track', 'Search'
          # search_string: ''
      when 'Add to Wishlist'
        fbq 'track', 'AddToWishList'
    cb null

  viewedCheckoutStep: (event, props, opts, cb = ->) ->
    return if props.step? and props.step > 1
    fbq 'track', 'InitiateCheckout'
      # value:    props.value
      # currency: props.currency ? 'USD'
      # content_name: ''
      # content_category: ''
      # content_ids: ''
      # num_items: ''

  completedCheckoutStep: (event, props, opts, cb = ->) ->
    return if props.step? and props.step > 1
    fbq 'track', 'AddPaymentInfo'
      # value:    props.value
      # currency: props.currency ? 'USD'
      # content_category: ''
      # content_ids: ''

  viewedProduct: (event, props, opts, cb = ->) ->
    fbq 'track', 'ViewContent',
      # value:    props.value
      # currency: props.currency ? 'USD'
      content_type: 'product'
      content_ids:   [props.id]
    cb null

  addedProduct: (event, props, opts, cb = ->) ->
    fbq 'track', 'AddToCart',
      # value:    props.value
      # currency: props.currency ? 'USD'
      content_type: 'product'
      content_ids:   [props.id]
    cb null

  completedOrder: (event, props, opts, cb = ->) ->
    ids = (product.sku ? product for product in props.products)
    fbq 'track', 'Purchase',
      value:    parseCurrency props.total
      currency: props.currency ? 'USD'
      content_type: 'product'
      content_ids:  ids
      num_items: ids.length
    cb null
