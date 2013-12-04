source 'https://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

gem 'rails', '3.2.16'
gem 'rails-i18n', :git => "https://github.com/alphagov/rails-i18n.git", :branch => "welsh_updates"
gem 'unicorn', '4.6.3'
gem 'mustache'
gem 'aws-ses', :require => 'aws/ses'
gem 'gelf'

gem 'plek', '1.5.0'
gem 'lograge', '~> 0.1.0'
gem 'statsd-ruby', '1.0.0', :require => 'statsd'
gem 'htmlentities', '4.3.1'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '3.20.0'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '7.18.0'
end

gem "addressable"
gem 'exception_notification', '3.0.1'
gem 'logstasher', '0.2.5'

gem 'rack_strip_client_ip', '0.0.1'

group :assets do
  gem 'govuk_frontend_toolkit', '0.36.0'
  gem 'sass', "3.2.1"
  gem 'sass-rails', "  ~> 3.2.3"
  gem "therubyracer", "~> 0.9.4"
  gem 'uglifier'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  gem "mocha", '0.13.3', :require => false
  gem "webmock", :require => false
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'test-unit'
  gem 'capybara', '2.1.0'
  gem 'poltergeist', '1.3.0'
  gem "launchy"
  gem "shoulda"
  gem "timecop", "0.6.3"
end
