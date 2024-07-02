require "simplecov"
SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage 95
  add_filter "/lib/api_error_routing_constraint.rb"
  add_filter "/lib/bank_holiday_generator.rb"
  add_filter "/lib/format_routing_constraint.rb"
  add_filter "/lib/frontend.rb"
end

require "i18n/coverage"
require "i18n/coverage/printers/file_printer"
I18n::Coverage.config.printer = I18n::Coverage::Printers::FilePrinter
I18n::Coverage.start

ENV["RAILS_ENV"] = "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "minitest/unit"
require "mocha/minitest"
require "webmock/minitest"
WebMock.disable_net_connect!(allow_localhost: true)
require "timecop"

Dir[Rails.root.join("test/support/*.rb")].sort.each { |f| require f }

class ActiveSupport::TestCase
  include ContentStoreHelpers

  setup do
    I18n.locale = :en

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :active_support
    end
  end

  teardown do
    Timecop.return
  end

  def prevent_implicit_rendering
    # we're not testing view rendering here,
    # so prevent rendering by stubbing out default_render
    @controller.stubs(:default_render)
  end
end
