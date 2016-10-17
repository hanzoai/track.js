Integration = require '../integration'

module.exports = class Bing extends Integration
  src:
    type: 'script'
    url:  '//bat.bing.com/bat.js'

  constructor: (@opts) ->

  init: ->
    window.uetq = window.uetq or []

    @load ->
      setup =
        ti: self.options.tagId
        q:  window.uetq

      window.uetq = new (window.UET)(setup)
      @ready()

  page: (event, props, cb) ->
    window.uetq.push 'pageLoad'
    cb null

  track: (event, props, cb) ->
    window.heap.track event, props
    cb null

    event =
      ea: 'track'
      el: event

    event.ec ?= props.category
    event.gv ?= props.revenue

    window.uetq.push event
