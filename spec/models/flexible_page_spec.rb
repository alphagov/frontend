RSpec.describe FlexiblePage do
  include GdsApi::TestHelpers::Search

  subject(:flexible_page) { ContentItemFactory.build(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }

  describe "#feed_items" do
    it "returns an empty list" do
      expect(flexible_page.feed_items).to eq([])
    end
  end
end
