RSpec.describe FieldsOfOperation do
  describe "#links" do
    subject(:fields_of_operation) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("fields_of_operation", example_name: "fields_of_operation")
    end

    it "returns the expected response" do
      expect(fields_of_operation.links["fields_of_operation"].first["title"]).to eq(content_store_response.dig("links", "fields_of_operation", 0, "title"))
    end
  end
end
