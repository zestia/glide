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
  source = File.read 'js/flight.js'
  header = source.match HEADER
  File.open 'js/flight-min.js', 'w+' do |file|
    file.write header[1].squeeze(' ') + Closure::Compiler.new.compress(source)
  end
end

desc 'compile the coffeescript and less stylesheet'
task :compile => [:coffee, :less]

desc 'compile the coffeescript source into javascript'
task :coffee do
  system 'coffee -c js/flight.coffee'
  system 'coffee -c js/application.coffee'
  system 'coffee -c js/routers/AppRouter.coffee'
  system 'coffee -c js/views/Views.coffee'
  
end

desc 'compile the less stylesheets into css'
task :less do
  system 'lessc --yui-compress css/style.less css/style.css'
end

desc 'build the docco documentation'
task :doc do
  system 'docco flight.js'
end

desc 'run JavaScriptLint on the source'
task :lint do
  system 'jsl -nofilelisting -nologo -conf docs/jsl.conf -process js/flight.js'
end
