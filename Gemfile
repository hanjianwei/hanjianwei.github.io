source "https://rubygems.org"

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']
gem 'html-proofer'

group :jekyll_plugins do
    gem 'jekyll-feed'
    gem 'jekyll-github-metadata'
    gem 'jekyll-mentions'
    gem 'jekyll-paginate'
end
