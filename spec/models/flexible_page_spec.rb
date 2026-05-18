RSpec.describe FlexiblePage do
  include GdsApi::TestHelpers::Search

  subject(:flexible_page) { ContentItemFactory.build(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }

  describe "#feed_items" do
    it "returns an empty list" do
      expect(flexible_page.feed_items).to eq([])
    end
  end
end
