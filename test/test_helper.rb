require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha/setup'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
require 'timecop'

require 'gds_api/test_helpers/content_api'

Dir[Rails.root.join('test/support/*.rb')].each { |f| require f }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...
  include GdsApi::TestHelpers::ContentApi

  teardown do
    Timecop.return
  end
end
