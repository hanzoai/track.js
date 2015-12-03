assert = require 'assert'
should = require('chai').should()

{getBrowser} = require './_util'

describe "Analytics (#{process.env.BROWSER})", ->
  browser = getBrowser()

  testPage = "http://localhost:#{process.env.PORT ? 3333}/test.html"

  it 'Should load', ->
    require '../src'
