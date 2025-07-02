RSpec.describe ServiceManualGuide do
  describe "#service_manual_guides" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("service_manual_guide", example_name: "service_manual_guide")
    end

    it "returns the expected response when calling content_owners" do
      expect(content_item.content_owners.first.content_store_response).to eq(content_store_response.dig("links", "content_owners", 0))
    end

    it "returns the expected response when calling topic" do
      expect(content_item.topic.content_store_response).to eq(content_store_response.dig("links", "service_manual_topics").first)
    end

    context "with parent" do
      let(:content_store_response) do
        GovukSchemas::Example.find("service_manual_guide", example_name: "point_page")
      end

      it "returns the expected response when calling parent" do
        expect(content_item.parent.content_store_response).to eq(content_store_response.dig("links", "parent").first)
      end
    end
  end
end
