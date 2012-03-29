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
  source = File.read 'flight.js'
  header = source.match HEADER
  File.open 'flight-min.js', 'w+' do |file|
    file.write header[1].squeeze(' ') + Closure::Compiler.new.compress(source)
  end
end

desc 'build the docco documentation'
task :doc do
  check 'docco', 'docco', 'https://github.com/jashkenas/docco'
  system 'docco flight.js'
end

desc 'run JavaScriptLint on the source'
task :lint do
  check 'jsl', 'JavaScriptLint', 'http://www.javascriptlint.com/download.htm'
  system 'jsl -nofilelisting -nologo -conf docs/jsl.conf -process flight.js'
end

def check(exec, name, url)
  return unless `which #{exec}`.empty?
  puts "#{name} not found.\nInstall it from #{url}"
  exit
end
