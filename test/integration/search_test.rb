require 'integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest

  should "return a 405 for POST requests to /search" do
    post "/search?q=foo"
    assert_equal 405, response.status
  end

  should "allow us to embed search results in an iframe" do
    stub_request(:get, %r[#{Plek.new.find('search')}/unified_search.json*])
      .to_return(body: JSON.dump(results: [], facets: []))

    get "/search?q=tax"

    assert_equal "ALLOWALL", response.headers["X-Frame-Options"]
  end
end
