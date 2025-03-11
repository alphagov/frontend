RSpec.describe ServiceManualHomepage do
  describe "#topics" do
    subject(:service_manual) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("service_manual_homepage", example_name: "service_manual_homepage")
    end

    it "returns the expected response" do
      expect(service_manual.topics.length).to eq(4)
      expect(service_manual.topics.first.title).to eq(content_store_response.dig("links", "children", 0, "title"))
    end
  end
end
