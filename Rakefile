require 'rubygems'
require 'fileutils'

SOURCE = './dist'
TARGET = './demo/lib'

desc 'compile coffeescript'
task :coffee do
  system 'coffee -c -o dist/ src/coffee/*.coffee'
end

desc 'compile less'
task :less do
  system 'lessc -x src/less/glide.less dist/glide.css'
  system 'lessc -x src/less/theme/glide.theme.less dist/glide.theme.css'
end

desc 'copy dest into demo'
task :copyDirectory do
    FileUtils.rm_rf(TARGET)
    FileUtils.mkdir_p(TARGET)

    files = FileList.new.include("#{SOURCE}/*");

    files.each do |file|
        targetDir = file.sub(SOURCE, TARGET)
        FileUtils.mkdir_p(File.dirname(targetDir));
        FileUtils.cp_r(file, targetDir)
    end
end

desc 'publish gh-pages branch'
task :publish do
  ENV['GIT_DIR'] = File.expand_path(`git rev-parse --git-dir`.chomp)
  old_sha = `git rev-parse refs/remotes/origin/gh-pages`.chomp

  Dir.chdir('demo') do
    ENV['GIT_INDEX_FILE'] = gif = '/tmp/dev.gh.i'
    ENV['GIT_WORK_TREE'] = Dir.pwd

    File.unlink(gif) if File.file?(gif)

    `git add -A`

    tsha = `git write-tree`.strip
    puts "Created tree #{tsha}"

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
