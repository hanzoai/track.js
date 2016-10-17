data = Crowdstart?.Shop?.data

module.exports =
  total: ->
    if data?
      data.get 'order.total'
    else
      0
  items:
    if data?
      data.get 'order.items'
    else
      []
