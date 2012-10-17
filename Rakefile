require 'rubygems'

desc 'compile coffeescript into javascript'
task :coffee do
  system 'coffee -co lib/ src/coffee/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'lessc --yui-compress src/less/flight.less lib/flight.css'
end

desc 'Deploy to local development server'
task :deploy do
  system 'mkdir -p /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/{flight,flight/lib,flight/demo}'
  system 'cp -r lib/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/lib'
  system 'cp -r demo/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/demo'
  puts "Flight demo deployed to .war"
end

desc 'compile coffeescript and less and deploy'
task :default => [:coffee, :less, :deploy]