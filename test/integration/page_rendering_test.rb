require 'integration_test_helper'

class PageRenderingTest < ActionDispatch::IntegrationTest
  context "backend error handling" do
    context "backend timeout" do
      setup do
        stub_request(:get, %r[http://content-store.dev.gov.uk/*]).
          to_return(status: 200, body: {}.to_json)

        stub_request(:get, "#{Plek.new.find('contentapi')}/my-item.json").to_timeout
      end

      should "return 503 if backend times out" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end

    context "backend 500 error" do
      setup do
        stub_request(:get, %r[http://content-store.dev.gov.uk/*]).
          to_return(status: 200, body: {}.to_json)

        stub_request(:get, "#{Plek.new.find('contentapi')}/my-item.json").to_return(status: 500)
      end

      should "return 503" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end

    context "backend connection refused" do
      setup do
        stub_request(:get, %r[http://content-store.dev.gov.uk/*]).
          to_return(status: 200, body: {}.to_json)

        stub_request(:get, "#{Plek.new.find('contentapi')}/my-item.json").to_raise(Errno::ECONNREFUSED)
      end

      should "return 503 if backend connection is refused" do
        visit "/my-item"
        assert_equal 503, page.status_code
      end
    end
  end

  test "viewing a licence page" do
    setup_api_responses('licence-generic')
    visit "/licence-generic"
    assert_equal 200, page.status_code
    assert page.has_content?("Licence overview copy"), %(expected there to be content Licence overview copy in #{page.text.inspect})
  end

  # Crude way of handling the situation described at
  # http://stackoverflow.com/a/3443678
  test "requests for gifs 404" do
    visit "/crisis-loans/refresh.gif"
    assert_equal 404, page.status_code

    visit "/refresh.gif"
    assert_equal 404, page.status_code

    visit "/pagerror.gif"
    assert_equal 404, page.status_code
  end
end
