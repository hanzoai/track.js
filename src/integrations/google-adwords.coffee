Integration = require '../integration'

module.exports = class Google extends Integration
  type: 'script'
  src: '//www.google-analytics.com/analytics.js'

  constructor: (@opts) ->
    @init()

  init: ->
    return if window.ga?

    ga = ->
      ga.q ?= []
      ga.q.push arguments
      return

    ga.l = 1 * new Date()
    window.GoogleAnalyticsObject = 'ga'
    window.ga = ga

    ga 'create', @opts.trackingId, 'auto'

  page: (category, name, properties, opts, cb) ->
    ga 'send', 'pageview',
      page:  opts.page
      title: opts.title
    cb null

  # Ecommerce methods
  addedProduct:          (event, properties, options, cb) ->
  completedOrder:        (event, properties, options, cb) ->
  removedProduct:        (event, properties, options, cb) ->
  viewedProduct:         (event, properties, options, cb) ->
  viewedProductCategory: (event, properties, options, cb) ->
