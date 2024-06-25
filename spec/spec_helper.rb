require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage 95
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "capybara/rails"
require "slimmer/rspec"
require "timecop"
require "webmock/rspec"
WebMock.disable_net_connect!(allow_localhost: true)

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

GovukTest.configure

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.include ContentStoreHelpers, type: :system

  config.include ComponentHelpers, type: :view

  config.before(:each, type: :system) do
    driven_by :rack_test
  end
end
