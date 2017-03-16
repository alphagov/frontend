require 'integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  setup do
    stub_search_page_in_content_store
  end

  should "allow us to embed search results in an iframe" do
    stub_any_rummager_search_to_return_no_results

    get "/search?q=tax"

    assert_equal "ALLOWALL", response.headers["X-Frame-Options"]
  end

  context "given an unscoped search" do
    should "display the correct results" do
      stub_unscoped_search("sandwiches")
      visit "/search?q=sandwiches"
      assert page.has_content? "Offshore sandwich device"
      assert page.has_content? "flood risk in Sandwich"
    end
  end

  context "given a search scoped to a manual" do
    setup do
      stub_search_to_return_results_scoped_to_manual
      stub_scope_object
      stub_unscoped_rummager_request
      @manuals_search_path = "/search?filter_manual=/hmrc-internal-manuals/company-taxation-manual&q=tax"
    end

    should "display the correct results from the scope" do
      visit @manuals_search_path
      assert page.has_content?("1,023 results found in Company Taxation Manual")
      assert page.has_link?("CTM35150 - Income Tax")
      assert page.has_link?("Display 44,423 results from all of GOV.UK")
      assert page.has_link?("Tax your vehicle")
    end
  end
end
