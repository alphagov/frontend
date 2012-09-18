require_relative "../integration_test_helper"

class HelpPagesTest < ActionDispatch::IntegrationTest

  should "render the help index page correctly" do
    visit "/help"

    within ".header-context nav[role=navigation] ol" do
      items = page.all("li").map(&:text)
      assert_equal ['Home', 'Help'], items
    end

  end
end
