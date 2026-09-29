RSpec.describe MiniSite do
  include GdsApi::TestHelpers::Search
  include SharedContexts::ContentItemImageArrays

  subject(:mini_site) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find(schema_name, example_name:) }
  let(:schema_name) { "mini_site" }
  let(:example_name) { "mini-site" }

  let(:search_results) do
    {
      results: [
        {
          link: "/news/my-item",
          title: "My Mini Site News Item",
          public_timestamp: "2025-12-01T00:00:01Z",
          display_type: "news",
          description: "What's up?",
        },
      ],
    }
  end

  before { stub_any_search.to_return(body: search_results.to_json) }

  describe "#featured_items" do
    it "returns an array of featured_item hashes" do
      expect(mini_site.featured_items.count).to eq(content_store_response["details"]["ordered_featured_documents"].count)
      expect(mini_site.featured_items.first.keys).to eq(%i[description heading_text href image_alt image_src])
    end
  end

  describe "#feed_items" do
    it "returns values from the feed service" do
      expect(mini_site.feed_items.count).to eq(1)
      expect(mini_site.feed_items.first.keys).to eq(%i[link metadata])
    end
  end

  describe "#header_image" do
    it "returns the first image of type header" do
      expect(mini_site.header_image[:type]).to eq("header")
    end

    context "when a logo is present instead of a header" do
      include_context "when details/images has a single image of type ", "logo"

      it "returns nil" do
        expect(mini_site.header_image).to be_nil
      end
    end

    context "when details/images is empty" do
      include_context "with no details/images"

      it "returns nil" do
        expect(mini_site.header_image).to be_nil
      end
    end
  end

  describe "#logo_image" do
    it "returns nil" do
      expect(mini_site.logo_image).to be_nil
    end

    context "when a logo image is present" do
      include_context "when details/images has a single image of type ", "logo"

      it "returns the first image of type logo" do
        expect(mini_site.logo_image[:type]).to eq("logo")
      end
    end

    context "when details/images is empty" do
      include_context "with no details/images"

      it "returns nil" do
        expect(mini_site.logo_image).to be_nil
      end
    end
  end

  describe "#ordered_navigation_items" do
    it "extracts the navigation items from links/shared_navigations/navigation_items as models" do
      expect(mini_site.ordered_navigation_items.count).to eq(3)
      expect(mini_site.ordered_navigation_items.first).to be_instance_of(described_class)
    end
  end
end
