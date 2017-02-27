source 'https://rubygems.org'

gem "addressable"
gem 'airbrake', '3.1.15' # newer version is incompatible with our Errbit as of 12/2016
gem 'appsignal', '~> 2.0'
gem 'cdn_helpers', '0.9'
gem 'gds-api-adapters', '~> 39.2.0'
gem 'gelf'
gem 'govuk_frontend_toolkit', '~> 4.12.0'
gem 'govuk_navigation_helpers', '~> 2.4.0'
gem 'htmlentities', '~> 4.3.0'
gem 'invalid_utf8_rejector', '~> 0.0.0'
gem 'logstasher', '~> 1.1.0'
gem 'nokogiri', '~> 1.6.8.0'
gem 'plek', '~> 1.12.0'
gem 'rack_strip_client_ip', '~> 0.0.0'
gem 'rails', '4.2.7.1' # version 5 is available
gem 'rails-i18n', '~> 4.0.0'
gem 'sass', '~> 3.4.0'
gem 'sass-rails'
gem 'slimmer', '~> 10.1.3'
gem 'sprockets-rails', "~> 2.3.0" # version 3.2 available, but breaks a test.
gem 'shared_mustache', '~> 1.0.0'
gem 'statsd-ruby', '1.0.0', require: 'statsd'
gem "therubyracer", "~> 0.12.0"
gem 'uglifier'
gem 'uk_postcode', '~> 2.1.0'
gem 'unicorn', '~> 4.9.0' # version 5 is available
gem 'govuk_ab_testing', '~> 0.1.4'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'ci_reporter_test_unit'
  gem 'govuk-lint'
  gem 'pry-byebug'
  gem 'ci_reporter_rspec'
end

group :test do
  gem 'capybara'
  gem 'ci_reporter'
  gem 'govuk-content-schema-test-helpers'
  gem 'govuk_schemas'
  gem "launchy"
  gem "mocha"
  gem 'poltergeist'
  gem 'shoulda-context'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem "timecop"
  gem "webmock", require: false
end
