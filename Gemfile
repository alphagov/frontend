source 'http://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

group :router do
  gem 'router-client', '2.0.3', require: 'router/client'
end

gem 'rails', '3.2.12'
gem 'rails-i18n', :git => "https://github.com/alphagov/rails-i18n.git", :branch => "welsh_updates"
gem 'unicorn', '4.3.1'
gem 'mustache'
gem 'aws-ses', :require => 'aws/ses'
gem 'gelf'

gem 'plek', '1.2.0'
gem 'lograge', '~> 0.1.0'
gem 'statsd-ruby', '1.0.0', :require => 'statsd'
gem 'rummageable', '0.5.0'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '3.11.0'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '4.9.0'
end

gem "addressable"
gem 'exception_notification'

group :assets do
  gem 'govuk_frontend_toolkit', '0.10.0'
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
