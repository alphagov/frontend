require 'integration_test_helper'

class SearchTest < ActionDispatch::IntegrationTest
  should "allow us to embed search results in an iframe" do
    stub_request(:get, %r[#{Plek.new.find('search')}/search.json*])
      .to_return(body: JSON.dump(results: [], facets: []))

    get "/search?q=tax"

    assert_equal "ALLOWALL", response.headers["X-Frame-Options"]
  end
end
