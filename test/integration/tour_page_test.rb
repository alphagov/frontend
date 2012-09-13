require_relative "../integration_test_helper"

class TourPageTest < ActionDispatch::IntegrationTest

  should "render the tour page correctly" do
    visit "/tour"

    within ".header-context nav[role=navigation] ol" do
      items = page.all("li").map(&:text)
      assert_equal ['Home', 'Tour'], items
    end
  end
end
