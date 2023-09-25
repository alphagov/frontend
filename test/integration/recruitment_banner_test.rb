require "integration_test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "User research banner is displayed on pages of interest" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "transaction")

    pages_of_interest =
      [
        "/get-information-about-a-company",
        "/check-if-you-need-tax-return",
        "/view-right-to-work",
        "/trade-tariff",
        "/register-for-self-assessment",
        "/file-your-confirmation-statement-with-companies-house",
      ]

    pages_of_interest.each do |path|
      transaction["base_path"] = path
      stub_content_store_has_item(transaction["base_path"], transaction.to_json)
      visit transaction["base_path"]

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Sign up to take part in user research", href: "https://surveys.publishing.service.gov.uk/s/SNFVW1/")
    end
  end

  test "User research banner is not displayed on all pages" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "transaction")
    transaction["base_path"] = "/nothing-to-see-here"
    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Sign up to take part in user research", href: "https://surveys.publishing.service.gov.uk/s/SNFVW1/")
  end
end
