RSpec.describe FieldOfOperation do
  describe "#fatality_notices" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("field_of_operation", example_name: "field_of_operation")
    end

    it "returns the expected response" do
      expect(content_item.fatality_notices.first.title).to eq(content_store_response.dig("links", "fatality_notices", 0, "title"))
      expect(content_item.fatality_notices.first.base_path).to eq(content_store_response.dig("links", "fatality_notices", 0, "base_path"))
      expect(content_item.fatality_notices.first.to_h["details"]).to eq(content_store_response.dig("links", "fatality_notices", 0, "details"))
    end
  end
end
