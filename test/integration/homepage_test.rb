require "integration_test_helper"

class HomepageTest < ActionDispatch::IntegrationTest
  setup do
    content_store_has_item("/", schema: "special_route")
  end

  should "render the homepage" do
    visit "/"
    assert_equal 200, page.status_code
    assert_equal "Welcome to GOV.UK", page.title
  end
end
