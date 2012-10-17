require 'rubygems'

desc 'compile coffeescript into javascript'
task :coffee do
  system 'mkdir -p build/'
  system 'coffee -co lib/ src/coffee/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'mkdir -p build/'
  system 'lessc --yui-compress less/flight.less build/flight.css'
enddesc 'compile coffeescript and less and deploy'
task :default => [:coffee, :less, :deploy]