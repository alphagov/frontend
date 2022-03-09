source "https://rubygems.org"
ruby File.read(".ruby-version")

gem "rails", "6.1.4.7"

gem "addressable"
gem "dalli"
gem "gds-api-adapters"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_personalisation"
gem "govuk_publishing_components"
gem "htmlentities"
gem "invalid_utf8_rejector"
gem "plek"
gem "rack_strip_client_ip"
gem "rails-i18n"
gem "sassc-rails"
gem "slimmer"
gem "sprockets-rails"
gem "uglifier"
gem "uk_postcode"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "listen"
end

group :development, :test do
  gem "climate_control"
  gem "dotenv-rails"
  gem "govuk_test"
  gem "jasmine"
  gem "jasmine_selenium_runner"
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry-byebug"
  gem "rails_translation_manager"
  gem "rubocop-govuk"
end

group :test do
  gem "govuk-content-schema-test-helpers"
  gem "govuk_schemas"
  gem "i18n-coverage"
  gem "mocha"
  gem "rails-controller-testing"
  gem "shoulda-context"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
