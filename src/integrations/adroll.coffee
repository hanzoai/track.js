import Integration  from '../integration'
import identity     from '../identity'
import page         from '../page'

class AdRoll extends Integration
  src:
    type: 'script'
    url:
      https: 'https://s.adroll.com/j/roundtrip.js'
      http:  'https://a.adroll.com/j/roundtrip.js'

  constructor: (@opts) ->

  init: ->
    return if window.__adroll_loaded?
    window.adroll_adv_id = @opts.advId
    window.adroll_pix_id = @opts.pixId
    window.__adroll_loaded = true

  identify: (userId, props, cb) ->
    window.adroll_email props.email ? userId

  page: (category, name, props, cb) ->
    @track page.title()
    cb null

  track: (event, props, cb) ->
    data =
      user_id:                 identity.id()
      order_id:                props.orderId
      adroll_conversion_value: props.revenue
      adroll_currency:         props.currency ? 'USD'

    window.__adroll.record_user data

export default AdRoll
