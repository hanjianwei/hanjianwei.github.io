require 'rake'
require 'jekyll'
require 'yaml'

# Read config from YAML
config = Jekyll::Configuration::DEFAULTS.deep_merge(YAML.load_file('_config.yml'))

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
  else
    puts "Creating new post: #{filename}"

    open(filename, 'w') do |post|
      post.puts "---"
      post.puts "layout: post"
      post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
      post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M')}"
      post.puts "tags: "
      post.puts "---"
    end
  end

  system "vim #{filename}"
end

desc "compile and run the site"
task :default do
  pids = [
    spawn("jekyll server -w"),
    spawn("scss --watch _assets:assets"),
    spawn("coffee -b -w -o assets -c _assets/*.coffee")
  ]

  trap "INT" do
    Process.kill "INT", *pids
    exit 1
  end

  loop do
    sleep 1
  end
end
