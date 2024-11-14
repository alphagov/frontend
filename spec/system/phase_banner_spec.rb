require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Phase Banner" do
  let(:base_path) { "/help/about-govuk" }
  context "in the live phase" do
    before do
      content_store_has_example_item(base_path, schema: :help_page, example: "about-govuk")
    end

    it "has no banner" do
      visit base_path

      expect(page).not_to have_selector("div.govuk-phase-banner")
    end
  end

  context "in the beta phase" do
    before do
      content_item = GovukSchemas::Example.find(:help_page, example_name: "about-govuk")
      content_item["base_path"] = base_path
      content_item["phase"] = "beta"
      stub_content_store_has_item(base_path, content_item)
    end

    it "has no banner" do
      visit base_path

      expect(page).to have_selector("div.govuk-phase-banner")
    end
  end
end
