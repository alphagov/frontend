source 'http://rubygems.org'
source 'https://gems.gemfury.com/vo6ZrmjBQu5szyywDszE/'

gem 'rummageable', :git => 'git://github.com/alphagov/rummageable.git'
gem 'gds-warmup-controller'

group :router do
  gem 'router-client', '2.0.3', require: 'router/client'
end

gem 'rails', '3.2.7'
gem 'rails-i18n', :git => "https://github.com/alphagov/rails-i18n.git", :branch => "welsh_updates"
gem 'unicorn', '4.3.1'
gem 'mustache'
gem 'aws-ses', :require => 'aws/ses'
gem 'gelf'

gem 'plek', '0.5.0'
gem 'lograge'
gem 'statsd-ruby', '1.0.0', :require => 'statsd'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '3.9.4'
end

if ENV['GEO_DEV']
  gem 'rack-geo', :path => '../rack-geo'
  gem 'geogov', :path => '../geogov'
else
  gem 'rack-geo', '~> 0.8.6'
  gem 'geogov', '~> 0.0.12'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '4.1.3'
end

gem "addressable"
gem 'exception_notification'

group :assets do
  gem 'govuk_frontend_toolkit', '0.9.0'
  gem 'sass', "3.2.1"
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem "therubyracer", "~> 0.9.4"
  gem 'uglifier'
end

group :test do
  gem "mocha", :require => false
  gem "webmock", :require => false
  gem "ZenTest"
  gem "autotest-rails"
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'test-unit'
  gem 'capybara', '1.1.2'
  gem 'poltergeist', '0.7.0'
  gem "launchy"
  gem "shoulda"
end
