require 'rake'
require 'jekyll'
require 'yaml'
require 'stringex'

# Read config from YAML
config = Jekyll::DEFAULTS.deep_merge(YAML.load_file('_config.yml'))

source_dir = config['source']
posts_dir  = "_posts"

desc "Begin a new post in #{source_dir}/#{posts_dir}"
task :new_post, :title do |t, args|
  if args.title
    title = args.title
  else
    print "Enter a title for your post: "
    title = STDIN.gets.chomp
  end

  filename = "#{source_dir}/#{posts_dir}/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.md"
  if File.exist?(filename)
    puts "#{filename} already exists."
  end
  puts "Creating new post: #{filename}"

  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
    post.puts "tags: "
    post.puts "---"
  end

  system "vim #{filename}"
end

desc "preview the site in a web browser"
task :preview do
  puts "Starting to watch source with Jekyll and Compass."
  jekyllPid = Process.spawn("jekyll --auto --server")
  compassPid = Process.spawn("compass watch")

  trap("INT") {
    [jekyllPid, compassPid].each { |pid| Process.kill(8, pid) rescue Errno::ESRCH }
    exit 0
  }

  [jekyllPid, compassPid].each { |pid| Process.wait(pid) }
end

