require "integration_test_helper"

class PerformanceTest < ActionDispatch::IntegrationTest
  setup do
    payload = {
      base_path: "/performance",
      format: "special_route",
      title: "Performance platform",
      description: "",
    }
    stub_content_store_has_item("/performance", payload)
  end

  context "visiting /performance" do
    should "render the performance index page correctly" do
      visit "/performance"

      assert_has_component_title "Performance"
    end
  end
end
