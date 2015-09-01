require 'integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  should "return a 405 for POST requests to /search" do
    post "/search?q=foo"
    assert_equal 405, response.status
  end
end
