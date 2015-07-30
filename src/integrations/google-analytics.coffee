Integration = require '../integration'

trackProduct = (props) ->
   ga 'ec:addProduct',
      id:       props.id ? props.sku
      name:     props.name
      category: props.category
      quantity: props.quantity
      price:    props.price
      brand:    props.brand
      variant:  props.variant
      currency: props.currency

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

  identify: (userId, traits, options, callback) ->
    # var opts = this.options;

    # if (opts.sendUserId && identify.userId()) {
    #   window.ga('set', 'userId', identify.userId());
    # }

    # // Set dimensions
    # var custom = metrics(user.traits(), opts);
    # if (len(custom)) window.ga('set', custom);

  page: (category, name, properties, opts, cb = ->) ->
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

      if props.campaign?
        data.campaignName    = props.campaign.name
        data.campaignSource  = props.campaign.source
        data.campaignMedium  = props.campaign.medium
        data.campaignContent = props.campaign.content
        data.campaignKeyword = props.campaign.term

    ga 'send', 'event', data
    cb null

  # Ecommerce methods
  addedProduct: (event, properties, options, cb) ->
    # this.loadEnhancedEcommerce(track);
    # enhancedEcommerceProductAction(track, 'add');
    # this.pushEnhancedEcommerce(track);

  completedOrder: (event, properties, options, cb) ->
    # var total = track.total() || track.revenue() || 0;
    # var orderId = track.orderId();
    # var products = track.products();
    # var props = track.properties();

    # // orderId is required.
    # if (!orderId) return;

    # this.loadEnhancedEcommerce(track);

    # each(products, function(product) {
    #   var productTrack = createProductTrack(track, product);
    #   enhancedEcommerceTrackProduct(productTrack);
    # });

    # window.ga('ec:setAction', 'purchase', {
    #   id: orderId,
    #   affiliation: props.affiliation,
    #   revenue: total,
    #   tax: track.tax(),
    #   shipping: track.shipping(),
    #   coupon: track.coupon()
    # });

    # this.pushEnhancedEcommerce(track);

  removedProduct: (event, properties, options, cb) ->
    # this.loadEnhancedEcommerce(track);
    # enhancedEcommerceProductAction(track, 'remove');
    # this.pushEnhancedEcommerce(track);

  viewedProduct: (event, properties, options, cb) ->
    # this.loadEnhancedEcommerce(track);
    # enhancedEcommerceProductAction(track, 'detail');
    # this.pushEnhancedEcommerce(track);
