require 'integration_test_helper'

class ErrorHandlingTest < ActionDispatch::IntegrationTest
  context "when the content API returns 404" do
    should "return 404 status" do
      api_returns_404_for('/slug.json')
      visit "/slug"
      assert_equal 404, page.status_code
    end
  end

  context "when the content API returns 410" do
    should "return 410 status" do
      api_returns_error_for('/slug.json', 410)
      visit '/slug'
      assert_equal 410, page.status_code
    end
  end

  context "when the content API returns 5xx" do
    should "return 503 status" do
      api_returns_error_for('/slug.json', 500)
      visit "/slug"
      assert_equal 503, page.status_code
    end
  end

  context "when the application tries to retrieve an invalid URL from the content API" do
    should "return 404 status" do
      api_throws_exception_for('/slug.json', GdsApi::InvalidUrl.new)
      visit '/slug'
      assert_equal 404, page.status_code
    end
  end

  context "when the content API times out" do
    should "return 503 status" do
      api_times_out_for('/slug.json')
      visit "/slug"
      assert_equal 503, page.status_code
    end
  end

  context "when the content API refuses the connection" do
    should "return 503 status" do
      api_fails_to_connect_for('/slug.json')
      visit '/slug'
      assert_equal 503, page.status_code
    end
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
