do (window=window, document=document, src='%s') ->
  return if window.analytics?

  analytics = []
  analytics.methods = [
    'ab'
    'alias'
    'group'
    'identify'
    'off'
    'on'
    'once'
    'page'
    'pageview'
    'ready'
    'track'
    'trackClick'
    'trackForm'
    'trackLink'
    'trackSubmit'
  ]

  for method in analytics.methods
    do (method) ->
      analytics[method] = ->
        event = Array::slice.call arguments
        event.unshift method
        analytics.push event
        analytics
      return

  script = document.createElement('script')
  script.async = true
  script.type = 'text/javascript'
  script.src = src
  first = document.getElementsByTagName('script')[0]
  first.parentNode.insertBefore script, first

  # Expose globally
  window.analytics = analytics
