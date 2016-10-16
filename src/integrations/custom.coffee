Integration = require '../integration'

module.exports = class Custom extends Integration
  constructor: (@opts) ->
    @src ?= @opts.src
    @fn   = new Function @opts.code

  track: (event, props, cb) ->
    return unless event == @opts.event

    try
      @fn event, props, cb
    catch err
      @log "Custom integration failed, #{err.toString()}"
