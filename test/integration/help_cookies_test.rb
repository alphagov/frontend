require "integration_test_helper"

class HelpCookiesTest < ActionDispatch::IntegrationTest
  context "rendering the cookies setting page" do
    setup do
      payload = {
        base_path: "/help/cookies",
        format: "special_route",
        title: "Cookies on GOV.UK",
        description: "You can choose which cookies you're happy for GOV.UK to use.",
      }
      stub_content_store_has_item("/help/cookies", payload)
    end

    should "render the cookies setting page correctly" do
      visit "/help/cookies"

      within "#content" do
        assert_has_component_title "Cookies on GOV.UK"
      end
    end

    should "have radio buttons set to disable cookies by default" do
      visit "/help/cookies"

      within "#content" do
        assert page.has_css?("input[name=cookies-usage][value=off][checked]")
        assert page.has_css?("input[name=cookies-campaigns][value=off][checked]")
        assert page.has_css?("input[name=cookies-settings][value=off][checked]")
      end
    end
  end
end
