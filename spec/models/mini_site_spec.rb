RSpec.describe MiniSite do
  include GdsApi::TestHelpers::Search

  subject(:mini_site) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("mini_site", example_name:) }
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

  shared_context "when there are no images" do
    let(:content_store_response) do
      GovukSchemas::Example.find("mini_site", example_name:).tap do |item|
        item["details"].delete("images")
      end
    end
  end

  shared_context "when it has a logo image instead of a header" do
    let(:content_store_response) do
      GovukSchemas::Example.find("mini_site", example_name:).tap do |item|
        item["details"]["images"][0]["type"] = "logo"
      end
    end
  end

  describe "#header_image" do
    it "returns the first image of type header" do
      expect(mini_site.header_image[:type]).to eq("header")
    end

    context "when a logo is present instead of a header" do
      include_context "when it has a logo image instead of a header"

      it "returns nil" do
        expect(mini_site.header_image).to be_nil
      end
    end

    context "when details/images is empty" do
      include_context "when there are no images"

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
      include_context "when it has a logo image instead of a header"

      it "returns the first image of type logo" do
        expect(mini_site.logo_image[:type]).to eq("logo")
      end
    end

    context "when details/images is empty" do
      include_context "when there are no images"

      it "returns nil" do
        expect(mini_site.logo_image).to be_nil
      end
    end
  end
end
