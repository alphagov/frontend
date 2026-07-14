RSpec.describe TopicalEventPresenter do
  subject(:topical_event_presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
  let(:content_item) { TopicalEvent.new(content_store_response) }

  describe "#breadcrumbs" do
    it "has no breadcrumbs" do
      expect(topical_event_presenter.breadcrumbs.count).to eq([])
    end
  end
end
