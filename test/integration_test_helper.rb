require "test_helper"
require "capybara/rails"
require "support/govuk_test"

require "slimmer/test"

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def setup
    super
    # Stub website_root to match test fixtures
    Frontend.stubs(:govuk_website_root).returns("https://www.gov.uk")

    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :capybara
    end
  end

  def teardown
    Capybara.use_default_driver
    WebMock.reset!
  end

  def setup_api_response(slug, options = {})
    options[:file] ||= "#{slug}.json"
    options[:deep_merge] ||= {}
    json = File.read(Rails.root.join("test/fixtures/#{options[:file]}"))
    content_item = JSON.parse(json).deep_merge(options[:deep_merge])
    content_store_has_page(slug, schema: content_item["format"])
    content_item
  end

  def assert_page_has_content(text)
    assert page.has_content?(text), %(expected there to be content #{text} in #{page.text.inspect})
  end

  def assert_page_is_full_width
    assert_not page.has_css?(".govuk-grid-row")
  end
end
