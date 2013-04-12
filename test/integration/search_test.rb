require_relative '../integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  context "redirecting JSON requests" do
    should "redirect to the public API for the search term" do
      get "/search.json?q=something"
      assert_redirected_to "/api/search.json?q=something"
    end

    should "redirect to the public API with no search term" do
      get "/search.json"
      assert_redirected_to "/api/search.json?q="
    end
  end
end
