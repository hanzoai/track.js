class Google
  constructor: (@opts) ->

  init: ->
    do (i = window, s = document, o = 'script', g = '//www.google-analytics.com/analytics.js', r = 'ga', a, m) ->
      i['GoogleAnalyticsObject'] = r
      i[r] = i[r] or ->
        (i[r].q = i[r].q or []).push arguments
        return

      i[r].l = 1 * new Date()

      a = s.createElement(o)
      m = s.getElementsByTagName(o)[0]

      a.async = 1
      a.src = g
      m.parentNode.insertBefore a, m
      return

    ga 'create', @trackingId, 'auto'

  page: (category, name, properties, opts, cb) ->
    ga 'send', 'pageview',
      page:  opts.page
      title: opts.title

  viewedProductCategory: (event, properties, options, cb) ->
  viewedProduct:         (event, properties, options, cb) ->
  addedProduct:          (event, properties, options, cb) ->
  removedProduct:        (event, properties, options, cb) ->
  completedOrder:        (event, properties, options, cb) ->
