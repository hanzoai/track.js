session = require './session'

# http://stackoverflow.com/questions/105034/how-to-create-a-guid-uuid-in-javascript/21963136#21963136
uuid = ->
  lut = []
  for i in [0...256]
    lut[i] = (if i < 16 then '0' else '') + i.toString(16)

  do ->
    d0 = Math.random() * 0xffffffff | 0
    d1 = Math.random() * 0xffffffff | 0
    d2 = Math.random() * 0xffffffff | 0
    d3 = Math.random() * 0xffffffff | 0
    lut[d0 & 0xff] +
    lut[d0 >> 8 & 0xff] +
    lut[d0 >> 16 & 0xff] +
    lut[d0 >> 24 & 0xff] + '-' +
    lut[d1 & 0xff] +
    lut[d1 >> 8 & 0xff] + '-' +
    lut[d1 >> 16 & 0x0f | 0x40] +
    lut[d1 >> 24 & 0xff] + '-' +
    lut[d2 & 0x3f | 0x80] +
    lut[d2 >> 8 & 0xff] + '-' +
    lut[d2 >> 16 & 0xff] +
    lut[d2 >> 24 & 0xff] +
    lut[d3 & 0xff] +
    lut[d3 >> 8 & 0xff] +
    lut[d3 >> 16 & 0xff] +
    lut[d3 >> 24 & 0xff]

identity = ->
  traits = (session.get 'identity') ? {}
  unless traits.userId?
    traits.userId = uuid()
  traits

identity.set = (k, v) ->
  traits = identity()
  traits[k] = v
  session.set 'identity', traits

identity.clear = ->
  session.remove 'identity'

module.exports = identity
