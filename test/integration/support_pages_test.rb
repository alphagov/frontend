require_relative "../integration_test_helper"

class SupportPagesTest < ActionDispatch::IntegrationTest

  should "render the support pages index page correctly" do
    visit "/support"

    within ".header-context nav[role=navigation] ol" do
      items = page.all("li").map(&:text)
      assert_equal ['Home', 'Support'], items
    end

  end
end
