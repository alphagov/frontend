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
      expect(mini_site.ordered_navigation_items.count).to eq(content_store_response["details"]["ordered_navigation_items"].count)
      expect(mini_site.ordered_navigation_items.first).to be_instance_of(described_class)
    end

    context "when there is no links/shared_navigations item" do
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["links"].delete("shared_navigations")
        end
      end

      it "returns an empty array" do
        expect(mini_site.ordered_navigation_items).to be_empty
      end
    end

    context "when there are no navigation items in links/shared_navigations" do
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["links"]["shared_navigations"][0]["navigation_items"] = []
        end
      end

      it "returns an empty array" do
        expect(mini_site.ordered_navigation_items).to be_empty
      end
    end
  end

  describe "#root_navigation_item" do
    it "extracts the root navigation item from links/shared_navigations/navigation_items as a model" do
      expect(mini_site.root_navigation_item).to be_instance_of(described_class)
      expect(mini_site.root_navigation_item.content_id).to eq(mini_site.content_id)
    end

    context "when there is no links/shared_navigations item" do
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["links"].delete("shared_navigations")
        end
      end

      it "returns nil" do
        expect(mini_site.root_navigation_item).to be_nil
      end
    end

    context "when there are no navigation items in links/shared_navigations" do
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["links"]["shared_navigations"][0]["navigation_items"] = []
        end
      end

      it "returns nil" do
        expect(mini_site.root_navigation_item).to be_nil
      end
    end
  end
end
