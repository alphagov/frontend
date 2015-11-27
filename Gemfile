source 'https://rubygems.org'

gem 'rails', '4.2.4'
gem 'rails-i18n', :git => "https://github.com/alphagov/rails-i18n.git", :branch => "welsh_updates"
gem 'unicorn', '4.6.3'
gem 'gelf'

gem 'plek', '1.11.0'
gem 'statsd-ruby', '1.0.0', :require => 'statsd'
gem 'htmlentities', '4.3.1'
gem 'shared_mustache', '1.0.0'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '9.0.0'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '25.0.0'
end

gem "addressable"
gem 'logstasher', '0.6.2'
gem 'airbrake', '3.1.15'
gem 'invalid_utf8_rejector', '0.0.1'
gem 'rack_strip_client_ip', '0.0.1'

gem 'uk_postcode', '2.1.0'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'pry'
  gem 'govuk-lint', "~> 0.3.0"
end

# Note that govuk_frontend_toolkit is only used here for SASS mixins and
# variables. Analytics and other javascript features are provided by static.
gem 'govuk_frontend_toolkit', '~> 4.1.0'
gem 'sass', '3.4.9'
gem 'sass-rails'
gem "therubyracer", "0.12.2"
gem 'uglifier'

group :test do
  gem "mocha", "~> 1.1.0"
  gem "webmock", :require => false
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'capybara', '2.1.0'
  gem 'poltergeist', '1.3.0'
  gem "launchy"
  gem "shoulda"
  gem "timecop", "0.6.3"
end
