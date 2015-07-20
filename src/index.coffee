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

class Facebook
  constructor: (@opts) ->

  init: ->
    do (f = window, b = document, e = 'script', v = '//connect.facebook.net/en_US/fbevents.js', n, t, s) ->
      return if f.fbq

      n = f.fbq = ->
        (if n.callMethod then n.callMethod.apply(n, arguments) else n.queue.push(arguments))
        return

      f._fbq = n unless f._fbq
      n.push = n
      n.loaded = not 0
      n.version = '2.0'
      n.queue = []
      t = b.createElement(e)
      t.async = not 0
      t.src = v
      s = b.getElementsByTagName(e)[0]
      s.parentNode.insertBefore t, s
      return

    fbq 'init', cfg.facebook.remarketingId

  page: (category, name, properties, opts, callback) ->
    fbq 'track', 'PageView'

class Analytics
  constructor: ->
    @integrations = []

    for method in [
      'viewedProductCategory'
      'viewedProduct'
      'addedProduct'
      'removedProduct'
      'completedOrder'
      'experimentViewed'
    ]
      @[method] = =>
        @call method, arguments

  # Call method for each integration
  call: (method, args...) ->
    for integration in @integrations
      if integration[method]?
        integration[method].apply @, args

  addIntegration: (name, opts = {}) ->
    switch name
      when 'Google Analytics'
        @integrations.push new Google opts
      when 'Facebook Conversion Tracking'
        @integrations.push new Facebook opts

  initialize: (integrations = {}) ->
    for k,v of integrations
      @addIntegration k, v

  identify: (userId, traits, options, callback) ->
    @call 'identify', userId, traits, options, callback

  track: (event, properties, options, callback) ->
    method = event.replace /\s+/g, ''
    method = method[0].toLowerCase() + method.substring 1

    if @method?
      @call method, properties, options, callback
    else
      @call 'track', properties, options, callback

  page: (category, name, properties, options, callback) ->
    @call 'page', category, name, properties, options, callback

  debug: (bool = true) ->
    @_debug = bool

  log: ->
    console?.log.apply @, arguments if @_debug

  # Un-implemented
  alias: (userId, previousId, options, callback) ->
  reset: ->
  ready: ->
  user: ->
  group: ->
  load: ->
  on: (event, cb) ->
    # cb expects `function(event, properties, options)`

