import Integration from '../integration'

class Heap extends Integration
  src:
    type: 'script'
    url:  -> "//cdn.heapanalytics.com/js/heap-#{@id}.js"

  constructor: (@opts) ->

  init: ->
    return if window.heap?

    window.heap = window.heap or []

    window.heap.load = (appid, config) ->
      window.heap.appid  = appid
      window.heap.config = config

      methodFactory = (type) ->
        ->
          window.heap.push [ type ].concat(Array::slice.call(arguments, 0))
          return

      heapMethods = [
        'addEventProperties'
        'addUserProperties'
        'clearEventProperties'
        'identify'
        'removeEventProperty'
        'setEventProperties'
        'track'
        'unsetEventProperty'
      ]
      for method in heapMethods
        window.heap[method] = methodFactory(method)

    window.heap.load @options.id

  track: (event, props, cb) ->
    window.heap.track event, props
    cb null

  identify: (userId, props, cb) ->
    window.identify userId
    window.heap.addUserProperties props

export default Heap
