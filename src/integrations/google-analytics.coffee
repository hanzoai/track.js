Integration = require '../integration'

module.exports = class GoogleAnalytics extends Integration
  type: 'script'
  src: '//www.google-analytics.com/analytics.js'

  constructor: (opts) ->
    for k,v of opts
      @[k] = v

  init: ->
    return if window.ga?

    # ((i, s, o, g, r, a, m) ->
    #   i["GoogleAnalyticsObject"] = r

    #   i[r] = i[r] or ->
    #     (i[r].q = i[r].q or []).push arguments
    #     return

    #   i[r].l = 1 * new Date()

    #   a = s.createElement(o)
    #   m = s.getElementsByTagName(o)[0]

    #   a.async = 1
    #   a.src = g
    #   m.parentNode.insertBefore a, m
    #   return
    # ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"

    window.GoogleAnalyticsObject = 'ga'

    ga = ->
      ga.q ?= []
      ga.q.push arguments
      return

    ga.l = 1 * new Date()
    window.ga = ga

    ga 'create', @trackingId, 'auto'

  page: (category, name, properties, opts, cb = ->) ->
    ga 'send', 'pageview',
      page:  opts?.page
      title: opts?.title
    cb null

  # Ecommerce methods
  addedProduct:          (event, properties, options, cb) ->
  completedOrder:        (event, properties, options, cb) ->
  removedProduct:        (event, properties, options, cb) ->
  viewedProduct:         (event, properties, options, cb) ->
  viewedProductCategory: (event, properties, options, cb) ->
