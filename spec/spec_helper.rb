require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "capybara/rails"
require "webmock/rspec"
require "slimmer/rspec"
WebMock.disable_net_connect!(allow_localhost: true)
require "timecop"

Dir[Rails.root.join("spec/support/*.rb")].sort.each { |f| require f }

GovukTest.configure

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include ContentStoreHelpers, type: :controller

  config.include Helpers::Components, type: :feature
  config.include ContentStoreHelpers, type: :feature
  config.include FeatureHelpers, type: :feature

  config.include Helpers::Components, type: :view
end
