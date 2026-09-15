RSpec.describe TopicalEventAboutPage do
  subject(:topical_event_about_page) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }

  describe "#contents_outline" do
    it "makes a content outline object from details/headers" do
      expect(topical_event_about_page.contents_outline).to be_instance_of(ContentsOutline)
      expect(topical_event_about_page.contents_outline.items.count).to eq(6)
      expect(topical_event_about_page.contents_outline.items.first.text).to eq("Response in the UK")
      expect(topical_event_about_page.contents_outline.items.first.id).to eq("response-in-the-uk")
    end
  end

  describe "#parent" do
    it "returns an object from links/parent/0" do
      expect(topical_event_about_page.parent.title).to eq("Ebola virus: UK government response")
      expect(topical_event_about_page.parent.base_path).to eq("/government/topical-events/ebola-virus-government-response")
    end
  end
end
