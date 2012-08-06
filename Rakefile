require 'rubygems'

HEADER = /((^\s*\/\/.*\n)+)/

desc 'rebuild the flight-min.js files for distribution'
task :build do
  begin
    require 'closure-compiler'
  rescue LoadError
    puts "closure-compiler not found."
    puts "Install it by running 'gem install closure-compiler'"
    exit
  end
  source = File.read 'build/flight.js'
  header = source.match HEADER
  File.open 'build/flight-min.js', 'w+' do |file|
    file.write header[1].squeeze(' ') + Closure::Compiler.new.compress(source)
  end
end

desc 'compile coffeescript and less'
task :default => [:coffee, :less]

desc 'compile coffeescript into javascript'
task :coffee do
  system 'mkdir -p build/'
  system 'coffee -c -o build/ js/*.coffee '
end

desc 'compile less into css'
task :less do
  system 'mkdir -p build/'
  system 'lessc --yui-compress less/flight.less build/flight.css'
end
