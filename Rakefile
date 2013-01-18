require 'rubygems'

desc 'compile coffeescript into javascript'
task :coffee do
  system 'coffee -co lib/ src/coffee/*.coffee'
  system 'coffee -c demo/app/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'lessc --yui-compress src/less/flight.less lib/flight.css'
  system 'lessc --yui-compress src/less/theme/flight.theme.less lib/flight.theme.css'
end

desc 'Deploy to local development server'
task :deploy do
  system 'mkdir -p /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/{flight,flight/lib,flight/demo}'
  system 'cp -r lib/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/lib'
  system 'cp -r demo/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/flight/demo'
  puts "Flight demo deployed to .war"
end

desc 'Copy compiled flight.js to capsule-mobile/vendor and deploy to calgary.war/m2/vendor'
task :m2 => [:coffee, :less, :deploy] do
  system 'cp -r lib/flight.js /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/m2/vendor'
  system 'cp -r lib/flight.js ~/Projects/capsule-mobile/vendor'
  puts "Flight copied to /m2"
end

desc 'compile coffeescript and less and deploy'
task :default => [:coffee, :less, :deploy]