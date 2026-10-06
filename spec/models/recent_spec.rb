RSpec.describe Recent do
  include GdsApi::TestHelpers::Search

  describe "#results" do
    let(:search_results) do
      {
        results: [
          {
            link: "/news/supergirl-justice",
            title: "Supergirl joins Justice League",
            public_timestamp: "2025-12-01T00:00:01Z",
            display_type: "news",
            description: "Supergirl joins the Justice League as the newest member of the team.",
          },
        ],
      }
    end

    before { stub_any_search.to_return(body: search_results.to_json) }

    it "asks for the most recent results" do
      expected_results = [{
        link: {
          text: "Supergirl joins Justice League",
          path: "/news/supergirl-justice",
        },
        metadata: {
          public_updated_at: "2025-12-01T00:00:01Z",
          document_type: "News",
          display_type: "news",
          description: "Supergirl joins the Justice League as the newest member of the team.",
        },
      }]

      expect(described_class.new.feed_items).to eq(expected_results)
    end

    it "calls FeedService with the expected count value" do
      stub_const("Recent::RESULTS_SIZE", 3)
      feed_service_args = { search_options: { count: Recent::RESULTS_SIZE } }
      feed_service = instance_double(FeedService)
      allow(FeedService).to receive(:new).with(feed_service_args).and_call_original
      allow(feed_service).to receive(:fetch_related_documents_with_format)

      described_class.new.feed_items

      expect(FeedService).to have_received(:new).with(hash_including(search_options: { count: 3 }))
    end
  end
end
