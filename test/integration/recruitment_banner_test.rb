require "integration_test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Recruitment Banner is displayed for the specified pages" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "transaction")
    transaction["base_path"] = "/vehicle-tax"

    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/3z828uy6")
  end

  test "Recruitment Banner is not displayed unless survey URL is specified for the base path" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "apply-blue-badge")

    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://GDSUserResearch.optimalworkshop.com/treejack/3z828uy6")
  end
end
