RSpec.describe Gone do
  subject(:content_item) { described_class.new(content_store_response) }

  let(:content_store_response) do
    GovukSchemas::Example.find("gone", example_name: "gone")
  end

  describe "#explanation" do
    it "returns the expected response" do
      expect(content_item.explanation).to eq(content_store_response.dig("details", "explanation"))
    end
  end

  describe "#alternative_path" do
    it "returns the expected response" do
      expect(content_item.alternative_path).to eq(content_store_response.dig("details", "alternative_path"))
    end
  end

  describe "#archived" do
    it "returns archived if alternative_path matches \"webarchive.nationalarchives.gov.uk\"" do
      content_item.content_store_response["details"]["alternative_path"] = "https://webarchive.nationalarchives.gov.uk"

      expect(content_item.alternative_path).to eq(content_store_response.dig("details", "alternative_path"))
    end
  end
end
