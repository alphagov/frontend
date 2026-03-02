RSpec.describe FeedService do
  include GdsApi::TestHelpers::Search

  subject(:feed_service) { described_class.new(search_options:) }

  let(:search_options) { { filter_topical_events: "my-topical-event" } }
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

  describe "#fetch_related_documents_with_format" do
    it "returns an array of related documents hashes" do
      expected = [{
        link: {
          text: "My Topical Event News Item",
          path: "/news/my-item",
        },
        metadata: {
          public_updated_at: "2025-12-01T00:00:01Z",
          document_type: "News",
          display_type: "news",
          description: "What's Up?",
        },
      }]

      expect(feed_service.fetch_related_documents_with_format).to eq(expected)
    end

    context "when display_type isn't available in results" do
      let(:search_results) do
        {
          results: [
            {
              link: "/news/my-item",
              title: "My Topical Event News Item",
              public_timestamp: "2025-12-01T00:00:01Z",
              content_store_document_type: "guidance",
            },
          ],
        }
      end

      it "returns the value of content_store_document_type as document_type" do
        expect(feed_service.fetch_related_documents_with_format.first[:metadata][:document_type]).to eq("Guidance")
      end
    end

    context "when neither display_type nor content_store_document_type is available in results" do
      let(:search_results) do
        {
          results: [
            {
              link: "/news/my-item",
              title: "My Topical Event News Item",
              public_timestamp: "2025-12-01T00:00:01Z",
            },
          ],
        }
      end

      it "returns empty string" do
        expect(feed_service.fetch_related_documents_with_format.first[:metadata][:document_type]).to eq("")
      end
    end
  end
end
