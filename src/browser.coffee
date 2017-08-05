unless window?
  document = require('jsdom').jsdom()
  document.domain = 'localhost'
  window   = document.defaultView

export window
export document
