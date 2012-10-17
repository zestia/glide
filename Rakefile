require 'rubygems'


desc 'compile coffeescript and less'
task :default => [:coffee, :less]

desc 'compile coffeescript into javascript'
task :coffee do
  system 'mkdir -p build/'
  system 'coffee -co lib/ src/coffee/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'mkdir -p build/'
  system 'lessc --yui-compress less/flight.less build/flight.css'
end