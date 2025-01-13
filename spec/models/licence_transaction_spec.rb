RSpec.describe LicenceTransaction do
  describe "#slug" do
    it "returns the subject slug" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "licence-transaction")
      content_store_response["base_path"] = "/foo/bar"
      expect(described_class.new(content_store_response).slug).to eq("bar")
    end
  end
end
