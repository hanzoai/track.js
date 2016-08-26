Integration = require '../integration'

module.exports = class Generic extends Integration
  constructor: (@opts) ->
    @src ?= @opts.src
    @fn   = new Function @opts.code

  track: (event, props, opts, cb = ->) ->
    return unless event == @opts.event

    try
      @fn event, props, opts, cb
    catch err
      @log "Generic integration failed, #{err.toString()}"
