RSpec.describe FieldsOfOperation do
  describe "#fields_of_operation" do
    subject(:content_item) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("fields_of_operation", example_name: "fields_of_operation")
    end

    it "returns the expected response" do
      expect(content_item.fields_of_operation.first.title).to eq(content_store_response.dig("links", "fields_of_operation", 0, "title"))
      expect(content_item.fields_of_operation.first.base_path).to eq(content_store_response.dig("links", "fields_of_operation", 0, "base_path"))
    end
  end
end
