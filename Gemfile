source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem 'mustache'

gem 'rack', '1.3.5'
gem 'rake', '0.9.2'
gem 'plek', '0.1.5'

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
gem 'exception_notification', '~> 2.4.1', :require => 'exception_notifier'

if ENV['CDN_DEV']
  gem 'cdn_helpers', :path => '../cdn_helpers'
else
  gem 'cdn_helpers', :git => 'git@github.com:alphagov/cdn_helpers.git'
end

group :test do
  gem "mocha"
  gem "webmock"
  gem "ZenTest"
  gem "autotest-rails"
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'test-unit'
end
