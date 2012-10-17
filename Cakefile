fs = require 'fs'

{print} = require 'sys'
{spawn} = require 'child_process'

task 'coffee', 'Build coffescript files to /lib', ->
  mkdir = spawn 'mkdir', ['-p','lib']

  coffee = spawn 'coffee', ['-co', 'lib', 'src/coffee/']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()

  coffe = spawn 'coffee', ['-c', 'demo/app/']
  coffee.stderr.on 'data', (data) ->
    process.stderr.write data.toString()

task 'less', 'Build less files to /lib', ->
  mkdir = spawn 'mkdir', ['-p','lib']

  less = spawn 'lessc', ['--yui-compress', 'src/less/flight.less', 'lib/flight.css']
  less.stderr.on 'data', (data) ->
    process.stderr.write data.toString()
  
task 'deploy', 'Deploy flight demo', ->

  deploy = spawn 'mkdir', ['-p', '/usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight /lib']
  deploy = spawn 'mkdir', ['-p', '/usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight /demo']
  
  # deploy = spawn 'cp', ['-r', '/usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/lib', 'lib/']
  # deploy.stderr.on 'data', (data) ->
  #   process.stderr.write data.toString()
  
  # # deploy = spawn 'cp', ['-r', 'demo/', '/usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/demo']
  # # deploy.stderr.on 'data', (data) ->
  # #   process.stderr.write data.toString()

task 'build', 'Builds coffeescript and less files and deploys to .war', ->
  invoke 'coffee'
  invoke 'less'
  invoke 'deploy'
 