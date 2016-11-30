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
end
