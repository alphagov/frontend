RSpec.describe WorldwideOffice do
  describe "#worldwide_office" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("worldwide_office", example_name: "worldwide_office")
    end

    it "returns the expected response when calling worldwide_organisation" do
      expect(content_item.worldwide_organisation.content_store_response).to eq(content_store_response.dig("links", "worldwide_organisation", 0))
    end

    it "returns the expected response when calling contact" do
      expect(content_item.contact.content_store_response).to eq(content_store_response.dig("links", "contact", 0))
    end
  end
end
