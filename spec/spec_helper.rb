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

RSpec.configure
