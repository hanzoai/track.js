Integration = require '../integration'

addProduct = (props) ->
  ga 'ec:addProduct',
    id:       props.id ? props.sku
    brand:    props.brand
    category: props.category
    coupon:   props.coupon
    currency: props.currency
    name:     props.name
    price:    props.price
    quantity: props.quantity
    variant:  props.variant

setAction = (action, props) ->
  ga 'ec:setAction', action, props

sendEvent = (event, props) ->
  ga 'send', 'event', (props.category ? 'EnhancedEcommerce'), event, nonInteraction: 1

module.exports = class GoogleAnalytics extends Integration
  type: 'script'
  src: '//www.google-analytics.com/analytics.js'

  constructor: (opts) ->
    for k,v of opts
      @[k] = v

  init: ->
    return if window.ga?

    window.GoogleAnalyticsObject = 'ga'

    ga = ->
      ga.q ?= []
      ga.q.push arguments
      return

    ga.l = 1 * new Date()
    window.ga = ga

    ga 'create', @trackingId, 'auto'

  identify: (userId, traits, opts, cb) ->
    # Do not send PII as id or extra metadata as it's against the
    # Google Analytics terms of service.
    ga 'set', 'userId', userId
    cb null

  page: (category, name, props, opts, cb = ->) ->
    ga 'send', 'pageview',
      page:     opts.page
      title:    opts.title
      location: opts.location
    cb null

  track: (event, props, opts, cb = ->) ->
    data =
      eventAction: event

    if props?
      data.eventCategory   = props.category
      data.eventLabel      = props.label
      data.eventValue      = props.value
      data.nonInteraction  = props.nonInteraction

      if (campaign = props.campaign)?
        data.campaignName    = campaign.name
        data.campaignSource  = campaign.source
        data.campaignMedium  = campaign.medium
        data.campaignContent = campaign.content
        data.campaignKeyword = campaign.term

    ga 'send', 'event', data
    cb null

  loadEnhancedEcommerce: (event, props) ->
    unless @enhancedEcommerceLoaded
      ga 'require', 'ec'
      @enhancedEcommerceLoaded = true

    # Ensure we set currency for every hit
    ga 'set', '&cu', props.currency ? 'USD'

  viewedProduct: (event, props, opts, cb) ->
    @loadEnhancedEcommerce event, props
    addProduct props
    setAction 'detail', props
    sendEvent event, props

  addedProduct: (event, props, opts, cb) ->
    @loadEnhancedEcommerce event, props
    addProduct props
    setAction 'add', props
    sendEvent event, props

  removedProduct: (event, props, opts, cb) ->
    @loadEnhancedEcommerce event, props
    addProduct props
    setAction 'remove', props
    sendEvent event, props

  completedOrder: (event, props, opts, cb) ->
    @loadEnhancedEcommerce event, props
    return unless props.orderId? and props.products?

    for product in props.products
      addProduct product

    setAction 'purchase',
      id:          props.orderId
      affiliation: props.affiliation
      revenue:     props.total
      tax:         props.tax
      shipping:    props.shipping
      coupon:      props.coupon

    sendEvent event, props
