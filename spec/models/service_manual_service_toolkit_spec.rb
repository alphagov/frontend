RSpec.describe ServiceManualServiceToolkit do
  describe "#topics" do
    subject(:service_toolkit) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("service_manual_service_toolkit", example_name: "service_manual_service_toolkit")
    end

    it "returns the expected response" do
      expect(service_toolkit.collections.length).to eq(2)
      expect(service_toolkit.collections.first["title"]).to eq(content_store_response.dig("details", "collections", 0, "title"))
    end
  end
end
