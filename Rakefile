require 'rubygems'
require 'fileutils'

@source = "./dist"
@target = "./demo/lib"
@includePattern = "/*"

desc 'compile coffeescript into javascript'
task :coffee do
  system 'coffee -c -o dist/ src/coffee/*.coffee'
end

desc 'compile less into css'
task :less do
  system 'lessc -x src/less/glide.less dist/glide.css'
  system 'lessc -x src/less/glide.android.less dist/glide.android.css'
  system 'lessc -x src/less/theme/glide.theme.less dist/glide.theme.css'
end

desc 'copy dest into demo'
task :copyDirectory do
    FileUtils.rm_rf(@target)  #remove target directory (if exists)
    FileUtils.mkdir_p(@target) #create the target directory
    files = FileList.new().include("#{@source}#{@includePattern}");
    files.each do |file|
        #create target location file string (replace source with target in path)
        targetLocation = file.sub(@source, @target)
        #ensure directory exists
        FileUtils.mkdir_p(File.dirname(targetLocation));
        #copy the file
        FileUtils.cp_r(file, targetLocation)
    end
end

task :publish do
  ENV['GIT_DIR'] = File.expand_path(`git rev-parse --git-dir`.chomp)
  old_sha = `git rev-parse refs/remotes/origin/gh-pages`.chomp
  Dir.chdir('demo') do
    ENV['GIT_INDEX_FILE'] = gif = '/tmp/dev.gh.i'
    ENV['GIT_WORK_TREE'] = Dir.pwd
    File.unlink(gif) if File.file?(gif)
    `git add -A`
    tsha = `git write-tree`.strip
    puts "Created tree   #{tsha}"
    if old_sha.size == 40
      csha = `echo 'boom' | git commit-tree #{tsha} -p #{old_sha}`.strip
    else
      csha = `echo 'boom' | git commit-tree #{tsha}`.strip
    end
    puts "Created commit #{csha}"
    puts `git show #{csha} --stat`
    puts "Updating gh-pages from #{old_sha}"
    `git update-ref refs/heads/gh-pages #{csha}`
    `git push origin gh-pages`
  end
end

task :default => [:coffee, :less, :copyDirectory]
