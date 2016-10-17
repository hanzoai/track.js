unless window?
  document = require('jsdom').jsdom()
  document.domain = 'localhost'
  window   = document.defaultView

module.exports =
  window:   window
  document: document
