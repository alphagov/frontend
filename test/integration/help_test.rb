# encoding: utf-8
require "integration_test_helper"

class HelpTest < ActionDispatch::IntegrationTest

  context "rendering the help index page" do
    setup do
      payload = {
        base_path: "/help",
        format: "special_route",
        title: "Help using GOV.UK",
        description: "",
      }
      content_store_has_item('/help', payload)
    end

    should "render the help index page correctly" do
      visit "/help"

      assert_breadcrumb_rendered

      within '#content header' do
        assert page.has_content?("Help using GOV.UK")
      end
    end
  end
end
