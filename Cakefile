exec = require('shortcake').exec

option '-b', '--browser [browserName]', 'browser to test with'
option '-g', '--grep [filter]', 'test filter'
option '-v', '--version [<newversion> | major | minor | patch | build]', 'new version'

task 'clean', 'clean project', (options) ->
  exec 'rm -rf lib'
  exec 'rm -rf .test'

task 'build', 'build project', (options) ->
  exec 'node_modules/.bin/coffee -bcm -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcm -o .test/ test/'

task 'watch', 'watch for changes and recompile project', ->
  exec 'node_modules/.bin/coffee -bcmw -o lib/ src/'
  exec 'node_modules/.bin/coffee -bcmw -o .test test/'

task 'publish', 'publish project', (options) ->
  newVersion = options.version ? 'patch'

  exec """
  git push
  npm version #{newVersion}
  npm publish
  """.split '\n'

task 'static-server', 'Run static server for tests', ->
  connect = require 'connect'
  server = connect()
  server.use (require 'serve-static') './test'
  server.listen process.env.PORT ? 3333

task 'selenium-install', 'Install selenium standalone', ->
  exec 'node_modules/.bin/selenium-standalone install'

task 'test', 'Run tests', (options) ->
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

task 'test-ci', 'Run tests on CI server', ->
  invoke 'static-server'

  browsers = require './test/ci-config'

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
