require 'rubygems'

desc 'compile coffeescript into javascript'
task :coffee do
  system 'coffee -co lib/ src/coffee/*.coffee'
  system 'coffee -c demo/app/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'lessc --yui-compress src/less/glide.less lib/glide.css'
  system 'lessc --yui-compress src/less/glide.android.less lib/glide.android.css'
  system 'lessc --yui-compress src/less/theme/glide.theme.less lib/glide.theme.css'
end

desc 'Deploy to local development server'
task :deploy do
  system 'mkdir -p /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/{glide,glide/lib,glide/demo}'
  system 'cp -r lib/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/glide/lib'
  system 'cp -r demo/* /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/glide/demo'
  puts "Glide demo deployed to .war"
end

desc 'Copy compiled glide.js to capsule-mobile/vendor and deploy to calgary.war/m2/vendor'
task :m2 => [:coffee, :less, :deploy] do
  system 'cp lib/glide.js /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/m2/vendor'
  system 'cp lib/glide.js ~/Projects/capsule-mobile/vendor'

  system 'cp lib/glide.menu.js /usr/local/jboss/server/default/deploy/calgary.ear/calgary.war/m2/vendor'
  system 'cp lib/glide.menu.js ~/Projects/capsule-mobile/vendor'
  puts "Glide copied to /m2"
end

task :default => [:coffee, :less, :deploy]
