require "percy/capybara"
require "uri"
# simplecov:disable
RSpec.describe "Visual regression tests", :visual_regression do
  include ContentStoreHelpers
  # rubocop:disable RSpec/NoExpectationExample
  describe "visual regression test runner Percy" do
    before { Capybara.current_driver = Capybara.javascript_driver }

    it "takes a screenshot of a subset of pages" do
      content_store_has_example_item("/government/organisations/government-digital-service/about", schema: :corporate_information_page, example: "corporate_information_page_with_groups")

      visit("/government/organisations/government-digital-service/about")
      page.find(:css, "body", wait: 10)
      page.percy_snapshot("Test")
    end
  end
  # rubocop:enable RSpec/NoExpectationExample
end
# simplecov:enable
