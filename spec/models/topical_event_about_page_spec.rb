RSpec.describe TopicalEventAboutPage do
  subject(:topical_event_about_page) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }

  describe "flexible_sections attribute" do
    it "generates flexible sections if not supplied" do
      expect(topical_event_about_page.flexible_sections.count).to eq(2)
      expect(topical_event_about_page.flexible_sections.first).to be_instance_of(FlexiblePage::FlexibleSection::PageTitle)
      expect(topical_event_about_page.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
    end
  end

  describe "#breadcrumbs" do
    it "extends the base breadcrumbs to add the parent event base_path" do
      expect(topical_event_about_page.breadcrumbs.count).to eq(2)
      expect(topical_event_about_page.breadcrumbs.last).to eq(
        {
          title: "Ebola virus: UK government response",
          url: "/government/topical-events/ebola-virus-government-response",
        },
      )
    end
  end
end
