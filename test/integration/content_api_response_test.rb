require "integration_test_helper"

class ContentApiResponseTest < ActionDispatch::IntegrationTest
  def status_for_url(path, status)
    path = "/#{path}" if path[0] != "/"
    response = {
      status: status,
      body: "{\"test\":\"bleh\"}"
    }
    stub_request(:get, "#{Plek.current.find("contentapi")}#{path}.json").to_return(response)
  end

  should "render the page with a 500 error code when receiving a 500 status" do
    status_for_url "/my-item", 500
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  should "render the page with a 500 error code when receiving a 501 status" do
    status_for_url "/my-item", 501
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  should "render the page with a 500 error code when receiving a 502 status" do
    status_for_url "/my-item", 502
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  should "render the page with a 500 error code when receiving a 503 status" do
    status_for_url "/my-item", 503
    visit "/my-item"
    assert_equal 503, page.status_code
  end

  should "render the page with a 500 error code when receiving a 504 status" do
    status_for_url "/my-item", 504
    visit "/my-item"
    assert_equal 503, page.status_code
  end
end
