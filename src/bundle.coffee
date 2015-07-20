do ->
  analytics = new (require './analytics')
  analytics.integrations {}
  analytics.initialize {}

  # Loop through the interim analytics queue and reapply the calls to their
  # proper analytics.js method.
  while window?.analytics?.length > 0
    item = window.analytics.shift()
    method = item.shift()
    if analytics[method]?
      analytics[method].apply analytics, item

  # Replace stub analytics
  window.analytics = analytics
