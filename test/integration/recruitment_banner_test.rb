require "integration_test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Brand user research banner is displayed on pages of interest" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "transaction")

    pages_of_interest =
      [
        "/check-national-insurance-record",
        "/check-mot-history",
      ]

    pages_of_interest.each do |path|
      transaction["base_path"] = path
      stub_content_store_has_item(transaction["base_path"], transaction.to_json)
      visit transaction["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://surveys.publishing.service.gov.uk/s/5G06FO/")
    end
  end

  test "Brand user research banner is not displayed on all pages" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "transaction")
    transaction["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://surveys.publishing.service.gov.uk/s/5G06FO/")
  end
end
