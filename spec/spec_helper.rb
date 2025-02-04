require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage 95
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "capybara/rails"
require "timecop"
require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukTest.configure

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :capybara
end

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.include FactoryBot::Syntax::Methods

  config.include ContentStoreHelpers, type: :request
  config.include ContentStoreHelpers, type: :system

  config.include ComponentHelpers, type: :view

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
