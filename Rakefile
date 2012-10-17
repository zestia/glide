require 'rubygems'

desc 'compile coffeescript into javascript'
task :coffee do
  system 'coffee -co lib/ src/coffee/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'lessc --yui-compress src/less/flight.less lib/flight.css'
end

task :default => [:coffee, :less, :deploy]