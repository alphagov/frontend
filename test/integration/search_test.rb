require_relative '../integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  context "redirecting JSON requests" do
    should "redirect to the public API for the search term" do
      get "/search.json?q=something"
      assert_redirected_to "/api/search.json?q=something"
    end

    should "properly quote query params when redirecting" do
      get "/search.json?q=does+this+work%3F"
      assert_redirected_to "/api/search.json?q=does+this+work%3F"
    end

    should "redirect to the public API with no search term" do
      get "/search.json"
      assert_redirected_to "/api/search.json?q="
    end
  end

  should "return a 405 for POST requests to /search" do
    post "/search?q=foo"
    assert_equal 405, response.status
  end
end
