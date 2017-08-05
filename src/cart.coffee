export default cart = ->
  data = Crowdstart?.Shop?.data
  unless data?
    return total: 0, items: [], ids: []

  items = data.get 'order.items'
  ids = []
  for item in items
    ids.push item.sku ? item.id

  total: data.get 'order.total'
  items: items
  ids:   ids
