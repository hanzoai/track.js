session = require './session'

module.exports = (sample, sampling = 1) ->
  if (sampled = (session.get sample))?
    return sampled

  if Math.random() < sampling
    session.set sample, false
    return false
  else
    session.set sample, true
    return true
