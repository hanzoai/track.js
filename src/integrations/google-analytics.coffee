Integration = require '../integration'

# Google Analytics only accepts ints as values
parseValue = (value) ->
  if typeof value == 'string'
    if (value.indexOf '.') != -1
      value = Math.round parseFloat value, 10
    else
      value = parseInt value, 10
  value

parseCurrency = (value) ->
  if typeof value == 'string'
    value
  else if typeof value == 'number'
    value.toFixed 2

# Google Analytics hates undefined/null properties, send them an object w/o
# keys pointing to such things.
payload = (opts = {}) ->
  data = {}
  for k,v of opts
    if v?
      data[k] = v
  data

module.exports = class GoogleAnalytics extends Integration
  src:
    type: 'script'
    url: '//www.google-analytics.com/analytics.js'

  constructor: (@opts) ->

  init: ->
    ((i, s, o, g, r, a, m) ->
      i['GoogleAnalyticsObject'] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments
        return

      i[r].l = 1 * new Date
    ) window, document, '', '', 'ga'
    window.GoogleAnalyticsObject = 'ga'
    ga 'create', @opts.id, 'auto'

  addProduct: (props) ->
    @log 'GoogleAnalytics.addProduct', arguments
    ga 'ec:addProduct', payload
      id:       props.id ? props.sku
      brand:    props.brand
      category: props.category
      coupon:   props.coupon
      currency: props.currency
      name:     props.name
      price:    parseCurrency props.price
      quantity: props.quantity
      variant:  props.variant

  setAction: (action, props) ->
    @log 'GoogleAnalytics.setAction', arguments
    ga 'ec:setAction', action, payload props

  sendEvent: (event, props = {}) ->
    @log 'GoogleAnalytics.sendEvent', arguments

    data =
      eventAction: event

    if props?
      data.eventCategory   = props.category
      data.eventLabel      = props.label
      data.eventValue      = parseValue props.value ? props.total ? props.revenue ? 0
      data.nonInteraction  = props.nonInteraction

      if (campaign = props.campaign)?
        data.campaignName    = campaign.name
        data.campaignSource  = campaign.source
        data.campaignMedium  = campaign.medium
        data.campaignContent = campaign.content
        data.campaignKeyword = campaign.term

    ga 'send', 'event', payload data

  sendEEEvent: (event, props) ->
    # props.nonInteraction = true
    props.category ?= 'EnhancedEcommerce'
    @sendEvent event, props

  identify: (userId, traits, opts, cb = ->) ->
    @log 'GoogleAnalytics.identify', arguments
    # Do not send PII as id or extra metadata as it's against the
    # Google Analytics terms of service.
    ga 'set', 'userId', userId
    cb null

  page: (category, name, props = {}, opts = {}, cb = ->) ->
    @log 'GoogleAnalytics.page', arguments

    ga 'set', payload opts
    ga 'send', 'pageview', payload opts

    cb null

  track: (event, props, opts, cb = ->) ->
    @log 'GoogleAnalytics.track', arguments
    @sendEvent event, props
    cb null

  loadEnhancedEcommerce: (event, props = {}) ->
    @log 'GoogleAnalytics.loadEnhancedEcommerce', arguments

    unless @_enhancedEcommerceLoaded
      ga 'require', 'ec'
      @_enhancedEcommerceLoaded = true

    # Ensure we set currency for every hit
    ga 'set', '&cu', props.currency ? 'USD'

  viewedProduct: (event, props, opts, cb = ->) ->
    @log 'GoogleAnalytics.viewedProduct', arguments
    @loadEnhancedEcommerce event, props
    @addProduct props
    @setAction 'detail', props
    @sendEEEvent event, props
    cb null

  addedProduct: (event, props, opts, cb = ->) ->
    @log 'GoogleAnalytics.addedProduct', arguments
    @loadEnhancedEcommerce event, props
    @addProduct props
    @setAction 'add', props
    @sendEEEvent event, props
    cb null

  removedProduct: (event, props, opts, cb = ->) ->
    @log 'GoogleAnalytics.removedProduct', arguments
    @loadEnhancedEcommerce event, props
    @addProduct props
    @setAction 'remove', props
    @sendEEEvent event, props
    cb null

  completedOrder: (event, props, opts, cb = ->) ->
    @log 'GoogleAnalytics.completedOrder', arguments
    @loadEnhancedEcommerce event, props
    return unless props.orderId? and props.products?

    @addProduct product for product in props.products

    @setAction 'purchase',
      id:          props.orderId
      affiliation: props.affiliation
      revenue:     parseCurrency props.total ? props.revenue
      tax:         parseCurrency props.tax
      shipping:    parseCurrency props.shipping
      coupon:      props.coupon

    @sendEEEvent event, props
    cb null
