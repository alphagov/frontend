RSpec.describe SpecialistDocumentPresenter do
  describe "#show_contents_list?" do
    it "returns false when there are no headers" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "business-finance-support-scheme")
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_contents_list?).to be false
    end

    it "returns true when there are level two headers" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports")
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_contents_list?).to be true
    end
  end
end
