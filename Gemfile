source 'https://rubygems.org'

gem 'rails', '4.2.5.1'

gem "addressable"
gem 'airbrake', '3.1.15'
gem 'gelf'
gem 'govuk_frontend_toolkit', '~> 4.1.0'
gem 'htmlentities', '4.3.1'
gem 'invalid_utf8_rejector', '0.0.1'
gem 'logstasher', '0.6.2'
gem 'nokogiri', '~> 1.6.7.2'
gem 'plek', '1.11.0'
gem 'rack_strip_client_ip', '0.0.1'
gem 'rails-i18n', :git => "https://github.com/alphagov/rails-i18n.git", :branch => "welsh_updates"
gem 'sass', '3.4.9'
gem 'sass-rails'
gem 'shared_mustache', '1.0.0'
gem 'sprockets-rails', "2.3.3" #FIXME: This is temporary, will allow to upgrade rails to 4.2.5.1 to address security fixes without breaking tests http://weblog.rubyonrails.org/2016/1/25/Rails-5-0-0-beta1-1-4-2-5-1-4-1-14-1-3-2-22-1-and-rails-html-sanitizer-1-0-3-have-been-released/
gem 'statsd-ruby', '1.0.0', :require => 'statsd'
gem "therubyracer", "0.12.2"
gem 'uglifier'
gem 'uk_postcode', '2.1.0'
gem 'unicorn', '4.6.3'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development, :test do
  gem 'govuk-lint', "~> 0.3.0"
  gem 'pry'
end

group :test do
  gem 'capybara', '2.1.0'
  gem 'ci_reporter'
  gem 'govuk-content-schema-test-helpers'
  gem "launchy"
  gem "mocha", "~> 1.1.0"
  gem 'poltergeist', '1.8.1'
  gem "shoulda"
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem "timecop", "0.6.3"
  gem "webmock", :require => false
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '26.7.0'
end

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', '0.9'
end

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '~> 9.0.0'
end
