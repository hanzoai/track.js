Integration = require '../integration'
cart        = require '../cart'

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
    @opts.values.currency ?= 'USD'
    @opts.values.viewedProduct ?=
      percent: 0.0001
    @opts.values.addedProduct ?=
      percent: 0.001
    @opts.values.initiateCheckout ?=
      percent: 0.01
    @opts.values.addPaymentInfo ?=
      percent: 0.02

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
    fbq.agent   = 'hza'
    # fbq.disablePushState = true # disable automatic page tracking

    window.fbq = window._fbq = fbq

    if @identity?
      fbq 'init', @opts.id, @identity
    else
      fbq 'init', @opts.id
    return

  identify: (userId, props, cb) ->
    @identity =
      em: props.email
      ph: props.phone
      fn: props.firstName
    cb null

  page: (category, name, props, cb) ->
    # fbq 'track', 'PageView'
    # Nothing to do as FB tracks this automatically
    cb null

  track: (event, props, cb) ->
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

  calcValue: (event, props = {}, total = 0) ->
    total    = math.Max(props.total, total)
    currency = props.currency ? @opts.values.currency

    # Allow value to be overridden
    if (value = props.values[event].value)?
      return [value, currency]

    # Calculate value as percentage of event total
    value = props.values[event].percent * total
    return [value, currency]

  viewedCheckoutStep: (event, props, cb) ->
    return if props.step? and props.step > 1

    {ids, total, items} = cart()
    [value, currency] = @calcValue 'initiateCheckout', props, total

    fbq 'track', 'InitiateCheckout',
      # content_category: ''
      content_ids: ids
      # content_name: ''
      currency:    currency
      num_items:   items.length
      value:       value
    cb null

  completedCheckoutStep: (event, props, cb) ->
    return if props.step? and props.step > 1

    {ids, total} = cart()
    [value, currency] = @calcValue 'addPaymentInfo', props, total

    fbq 'track', 'AddPaymentInfo',
      # content_category: ''
      content_ids: ids
      currency:    currency
      value:       value
    cb null

  viewedProduct: (event, props, cb) ->
    [value, currency] = @calcValue 'viewedProduct', props, props.price
    fbq 'track', 'ViewContent',
      content_ids:   [props.id]
      content_type: 'product'
      currency:     currency
      value:        value
    cb null

  addedProduct: (event, props, cb) ->
    [value, currency] = @calcValue 'addedProduct', props, props.price
    fbq 'track', 'AddToCart',
      # value:    props.value
      # currency: props.currency ? 'USD'
      content_type: 'product'
      content_ids:   [props.id]
    cb null

  completedOrder: (event, props, cb) ->
    ids = (product.sku ? product for product in props.products)
    fbq 'track', 'Purchase',
      value:    parseCurrency props.total
      currency: props.currency ? 'USD'
      content_type: 'product'
      content_ids:  ids
      num_items: ids.length
    cb null
