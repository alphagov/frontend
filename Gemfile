source 'https://rubygems.org'

gem "addressable"
gem 'airbrake', '3.1.15'
gem 'gelf'
gem 'govuk_frontend_toolkit', '~> 4.12.0'
gem 'govuk_navigation_helpers', '~> 2.0'
gem 'htmlentities', '4.3.1'
gem 'invalid_utf8_rejector', '0.0.1'
gem 'logstasher', '0.6.2'
gem 'nokogiri', '>= 1.6.8.1'
gem 'plek', '1.11.0'
gem 'rack_strip_client_ip', '0.0.1'
gem 'rails', '4.2.7.1'
gem 'rails-i18n', '~> 4.0.8'
gem 'sass', '>= 3.4.23'
gem 'sass-rails'
gem 'sprockets-rails', "2.3.3"
gem 'shared_mustache', '1.0.0'
gem 'statsd-ruby', '1.0.0', require: 'statsd'
gem "therubyracer", "0.12.2"
gem 'uglifier'
gem 'uk_postcode', '2.1.0'
gem 'unicorn', '4.6.3'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 10.0.0'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', path: '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '38.1.0'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'ci_reporter_test_unit'
  gem 'govuk-lint', "~> 1.2.0"
  gem 'pry-byebug'
end

group :test do
  gem 'capybara', '2.1.0'
  gem 'ci_reporter'
  gem 'govuk-content-schema-test-helpers'
  gem 'govuk_schemas', '~> 0.2'
  gem "launchy"
  gem "mocha", "~> 1.1.0"
  gem 'poltergeist', '1.8.1'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem "shoulda"
  gem "timecop", "0.6.3"
  gem "webmock", require: false
end
