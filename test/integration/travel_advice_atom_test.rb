require_relative '../integration_test_helper'

class TravelAdviceAtomTest < ActionDispatch::IntegrationTest

  context "on a single country page" do
    setup do
      setup_api_responses "travel-advice/luxembourg"
    end

    should "display the atom feed for a country" do
      visit "/travel-advice/luxembourg.atom"

      assert_equal 200, page.status_code

      assert page.has_xpath? ".//feed/title", :text => "Travel Advice Summary"
      assert page.has_xpath? ".//feed/link[@rel='self' and @href='http://www.example.com/travel-advice/luxembourg.atom']"
      assert page.has_xpath? ".//feed/entry/title", :text => "Luxembourg"
      assert page.has_xpath? ".//feed/entry/link[@href='https://www.gov.uk/travel-advice/luxembourg']"
      assert page.has_xpath? ".//feed/entry/summary", :text => "There are no parts of Luxembourg that the FCO recommends avoiding."
    end
  end
end
