require 'integration_test_helper'

class ErrorHandlingTest < ActionDispatch::IntegrationTest
  context "when the content store returns 404" do
    should "return 404 status" do
      content_store_does_not_have_item('/slug')
      visit "/slug"
      assert_equal 404, page.status_code
    end
  end

  context "when the content store returns 410" do
    should "return 410 status" do
      content_store_has_gone_item('/slug')
      visit '/slug'
      assert_equal 410, page.status_code
    end
  end

  context "when the application tries to retrieve an invalid URL from the content store" do
    should "return 404 status" do
      content_store_throws_exception_for('/foo', GdsApi::InvalidUrl)
      visit '/foo'
      assert_equal 404, page.status_code
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
