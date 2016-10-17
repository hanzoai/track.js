exec = require('shortcake').exec

use 'cake-version'
use 'cake-publish'

option '-b', '--browser [browserName]', 'browser to test with'
option '-g', '--grep [filter]', 'test filter'
option '-v', '--version [<newversion> | major | minor | patch | build]', 'new version'

task 'clean', 'clean project', (options) ->
  exec 'rm -rf lib'

task 'build', 'build project', (options) ->
  coffee = require 'coffee-script'
  fs     = require 'fs'

  exec 'node_modules/.bin/coffee -bcm -o lib/ src/'

  # build snippet for testing
  snippetJs = fs.readFileSync 'src/snippet.coffee', 'utf-8'
  snippetJs = coffee.compile snippetJs, bare: true
  snippetJs = snippetJs.replace /%s/, 'bundle.js'
  fs.writeFileSync 'test/fixtures/snippet.js', snippetJs, 'utf-8'

  config = coffee.compile """
  {
    integrations:
      [
        type: 'google-analytics'
        id: 'UA-65099214-1'
      ,
        type: 'facebook-pixel'
        id: '920910517982389'
      ,
        type: 'google-adwords'
        event: 'Sign-up'
        id: '945491661'
      ,
        type: 'facebook-conversions'
        event: 'Sign-up'
        id: '6025763568614'
      ,
        type: 'custom'
        name: 'Custom Sign-up callback'
        event: 'Sign-up'
        fn: (event, props, opts, cb) ->
          console.log "custom event!"
      ]
    }
    """, bare: true

  # clean up generated coffee-script
  config = config.replace '({', '{'
  config = config.replace '});\n', '}'

  # build bundled analytics (that snippet will load) for testing
  bundleJs = fs.readFileSync 'src/bundle.coffee', 'utf-8'
  bundleJs = coffee.compile bundleJs, bare: true
  bundleJs = bundleJs.replace /initialize\({}\)/, "initialize(#{config})"

  require('requisite').bundle
    entry: 'src/index.coffee'
    exclude: /jsdom/
  , (err, bundle) ->
    analyticsJs = bundle.toString()
    src = analyticsJs.replace /require\('\.\/index'\)/, bundleJs
    fs.writeFileSync 'test/fixtures/bundle.js', src, 'utf-8'

task 'watch', 'watch for changes and recompile project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'

task 'static-server', 'Run static server for tests', ->
  connect = require 'connect'
  server = connect()
  server.use (require 'serve-static') './test/fixtures'
  server.listen process.env.PORT ? 3333

task 'selenium-install', 'Install selenium standalone', ->
  exec 'node_modules/.bin/selenium-standalone install'

task 'test', 'Run tests', (options) ->
  invoke 'build'

  browserName = options.browser ? 'phantomjs'

  invoke 'static-server'

  selenium = require 'selenium-standalone'
  selenium.start (err, child) ->
    throw err if err?

    exec "NODE_ENV=test
          BROWSER=#{browserName}
          node_modules/.bin/mocha
          --compilers coffee:coffee-script/register
          --reporter spec
          --colors
          --timeout 60000
          test/test.coffee", (err) ->
      child.kill()
      process.exit 1 if err?
      process.exit 0

task 'test:ci', 'Run tests on CI server', ->
  invoke 'static-server'

  browsers = require './test/_browsers'

  tests = for {browserName, platform, version, deviceName, deviceOrientation} in browsers
    "NODE_ENV=test
     BROWSER=\"#{browserName}\"
     PLATFORM=\"#{platform}\"
     VERSION=\"#{version}\"
     DEVICE_NAME=\"#{deviceName ? ''}\"
     DEVICE_ORIENTATION=\"#{deviceOrientation ? ''}\"
     node_modules/.bin/mocha
     --compilers coffee:coffee-script/register
     --reporter spec
     --colors
     --timeout 60000
     test/test.coffee"

  exec tests, (err) ->
    process.exit 1 if err?
    process.exit 0
