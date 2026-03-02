RSpec.describe FlexiblePage do
  include GdsApi::TestHelpers::Search

  subject(:flexible_page) { ContentItemFactory.build(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("history", example_name: "history") }

  describe "#feed_items" do
    it "returns an empty list" do
      expect(flexible_page.feed_items).to eq([])
    end

    context "when a feed with items is present" do
      let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
      let(:search_results) do
        {
          results: [
            {
              link: "/news/my-item",
              title: "My Topical Event News Item",
              public_timestamp: "2025-12-01T00:00:01Z",
              display_type: "news",
              description: "What's Up?",
            },
          ],
        }
      end

      before { stub_any_search.to_return(body: search_results.to_json) }

      it "returns the items from the first feed in the page" do
        expect(flexible_page.feed_items).to eq([
          {
            link: {
              path: "/news/my-item",
              text: "My Topical Event News Item",
            },
            metadata: {
              document_type: "News",
              public_updated_at: "2025-12-01 00:00:01.000000000 +0000",
              display_type: "news",
              description: "What's Up?",
            },
          },
        ])
      end
    end
  end
end
