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
  gem 'simplecov', '0.4.2'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'test-unit'
end
