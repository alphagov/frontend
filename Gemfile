source "https://rubygems.org"
ruby "~> 3.2.0"

gem "rails", "7.1.3.2"

gem "addressable"
gem "bootsnap", require: false
gem "dalli"
gem "dartsass-rails"
gem "gds-api-adapters"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_personalisation"
gem "govuk_publishing_components", git: "https://github.com/alphagov/govuk_publishing_components.git", branch: "deploy-try-to-update-govukfrontend"
gem "htmlentities"
gem "invalid_utf8_rejector"
gem "plek"
gem "rails-i18n"
gem "rails_translation_manager"
gem "slimmer"
gem "sprockets-rails"
gem "terser"
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
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry-byebug"
  gem "rubocop-govuk"
end

group :test do
  gem "govuk_schemas"
  gem "i18n-coverage"
  gem "mocha"
  gem "rails-controller-testing"
  gem "shoulda-context"
  gem "simplecov"
  gem "timecop"
  gem "webmock"
end
