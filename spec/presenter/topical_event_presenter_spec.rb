RSpec.describe TopicalEventPresenter do
  subject(:topical_event_presenter) { described_class.new(content_item) }

  let(:content_item) { StatisticsAnnouncement.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "topical_event") }

  describe "#about_page_path" do
    it "returns the base path with about appended" do
      expect(topical_event_presenter.about_page_path).to eq("#{content_store_response['base_path']}/about")
    end
  end
end
