require "integration_test_helper"

class RecruitmentBannerTest < ActionDispatch::IntegrationTest
  test "Recruitment Banner is displayed for any page tagged to Money and Tax" do
    @money_and_tax_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/tax/self-assessment",
    }

    transaction = GovukSchemas::Example.find("transaction", example_name: "apply-blue-badge")
    transaction["links"]["mainstream_browse_pages"] << @money_and_tax_browse_page

    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/724268fr-1-0")
  end

  test "Recruitment Banner is displayed for any page tagged to Business and Self-employed" do
    @business_browse_page = {
      "content_id" => "123",
      "title" => "Self Assessment",
      "base_path" => "/browse/business",
    }

    transaction = GovukSchemas::Example.find("transaction", example_name: "apply-blue-badge")
    transaction["links"]["mainstream_browse_pages"] << @business_browse_page

    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert page.has_css?(".gem-c-intervention")
    assert page.has_link?("Take part in user research (opens in a new tab)", href: "https://GDSUserResearch.optimalworkshop.com/treejack/724268fr-1-0")
  end

  test "Recruitment Banner is not displayed unless page is tagged to a topic of interest" do
    transaction = GovukSchemas::Example.find("transaction", example_name: "apply-blue-badge")

    stub_content_store_has_item(transaction["base_path"], transaction.to_json)
    visit transaction["base_path"]

    assert_not page.has_css?(".gem-c-intervention")
    assert_not page.has_link?("Take part in user research", href: "https://GDSUserResearch.optimalworkshop.com/treejack/724268fr-1-0")
  end
end
