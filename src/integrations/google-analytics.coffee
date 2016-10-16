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
    @loadLinkAttribution() if opts.enableLinkAttribution

  addProduct: (props) ->
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
    ga 'ec:setAction', action, payload props

  sendEvent: (event, props = {}) ->
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

  sendEEvent: (event, props) ->
    @loadEcommerce event, props
    # props.nonInteraction = true
    props.category ?= 'EnhancedEcommerce'
    @sendEvent event, props

  identify: (userId, traits, opts, cb = ->) ->
    # Do not send PII as id or extra metadata as it's against the Google
    # Analytics terms of service.
    ga 'set', 'userId', userId
    cb null

  page: (category, name, props = {}, opts = {}, cb = ->) ->
    ga 'set', payload opts
    ga 'send', 'pageview', payload opts

    cb null

  track: (event, props, opts, cb = ->) ->
    @sendEvent event, props
    cb null

  loadLinkAttribution: (event, props = {}) ->
    unless @_loadedLinkAttribution
      ga 'require', 'linkid', props
      @_loadedLinkAttribution = true

  loadEcommerce: (event, props = {}) ->
    unless @_loadedEcommerce
      ga 'require', 'ec'
      @_loadedEcommerce = true

    # Ensure we set currency for every hit
    ga 'set', '&cu', props.currency ? 'USD'

  viewedProduct: (event, props, opts, cb = ->) ->
    @sendEEvent event, props
    @addProduct props
    @setAction 'detail', props
    cb null

  addedProduct: (event, props, opts, cb = ->) ->
    @sendEEvent event, props
    @addProduct props
    @setAction 'add', props
    cb null

  removedProduct: (event, props, opts, cb = ->) ->
    @sendEEvent event, props
    @addProduct props
    @setAction 'remove', props
    cb null

  completedOrder: (event, props, opts, cb = ->) ->
    return unless props.orderId? and props.products?

    @sendEEvent event, props
    @addProduct product for product in props.products
    @setAction 'purchase',
      id:          props.orderId
      affiliation: props.affiliation
      revenue:     parseCurrency props.total ? props.revenue
      tax:         parseCurrency props.tax
      shipping:    parseCurrency props.shipping
      coupon:      props.coupon
    cb null

  viewedCheckoutStep: (event, props, opts, cb = ->) ->
    @sendEEvent event, props
    @setAction 'checkout',
      steps: props.step ? 1
      option: opts
    cb null

  completedCheckoutStep: (event, props, opts, cb = ->) ->
    @sendEEvent event, props
    @setAction 'checkout_option',
      steps: props.step ? 1
      option: opts
    cb null
