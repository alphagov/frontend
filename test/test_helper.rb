require 'simplecov'
require 'simplecov-rcov'

SimpleCov.start 'rails'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'mocha'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)

require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/content_api'

require_relative '../lib/redirect_warden_factory'

Mocha::Integration.monkey_patches.each do |patch|
  require patch
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # Add more helper methods to be used by all tests here...
  include GdsApi::TestHelpers::Publisher
  include GdsApi::TestHelpers::ContentApi
end
