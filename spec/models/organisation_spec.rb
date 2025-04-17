RSpec.describe Organisation do
  let(:content_store_response) do
    GovukSchemas::Example.find("organisation", example_name: "organisation")
  end

  describe "#brand" do
    it "gets the brand" do
      expect(described_class.new(content_store_response).brand).not_to be_nil
      expect(described_class.new(content_store_response).brand).to eq(content_store_response.dig("details", "brand"))
    end
  end

  describe "#logo" do
    it "gets the logo" do
      expect(described_class.new(content_store_response).logo).to be_instance_of(Logo)
    end
  end
end
