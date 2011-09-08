source 'http://rubygems.org'

gem 'rails', '3.0.10'
gem 'mustache'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

if ENV['GOVSPEAK_DEV']
  gem 'govspeak', :path => '../govspeak'
else
  gem 'govspeak', :git => 'git@github.com:alphagov/govspeak.git'
end

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', :git => 'git@github.com:alphagov/slimmer.git'
end

if ENV['GEO_DEV']
  gem 'rack-geo', :path => '../rack-geo'
  gem 'geogov', :path => '../geogov'
else
  gem 'rack-geo', :git => 'git@github.com:alphagov/rack-geo.git'
  gem 'geogov', :git => 'git@github.com:alphagov/geogov.git'
end

gem "addressable"

gem 'cdn_helpers', :git => 'git@github.com:alphagov/cdn_helpers.git', :tag => 'v0.8.3'

group :test do
  gem "mocha"
  gem "webmock"
  gem "ZenTest"
  gem "autotest-rails"
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
end




# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
