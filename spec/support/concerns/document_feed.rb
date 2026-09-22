RSpec.shared_examples "it can present a document feed" do |document_type, example_name|
  include GdsApi::TestHelpers::Search

  let(:search_results) do
    {
      results: [
        {
          link: "/news/my-item",
          title: "My Topical Event News Item",
          public_timestamp: "2025-12-01T00:00:01Z",
          display_type: "news",
          description: "What's up?",
        },
      ],
    }
  end

  before { stub_any_search.to_return(body: search_results.to_json) }

  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:content_item) { ContentItemFactory.build(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#document_feed_options" do
    it "maps the ordered featured documents in the content item to a suitable format" do
      expect(presenter.document_feed_options).not_to be_nil
    end
  end

  describe "#feed_items" do
    it "can retrieve feed items" do
      expect(presenter.feed_items.count).not_to be_nil
    end
  end
end
