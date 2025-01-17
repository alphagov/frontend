RSpec.describe SpecialistDocumentPresenter do
  describe "#contents" do
    it "returns an empty array when there are no headers" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "business-finance-support-scheme")
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).contents).to eq([])
    end

    it "returns a contents list when there are level two headers" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports")
      content_item = SpecialistDocument.new(content_store_response)

      expected_contents = [
        {
          href: "#summary",
          items: [
            {
              href: "#download-report",
              level: 3,
              text: "Download report",
            },
            {
              href: "#download-glossary-of-abbreviations",
              level: 3,
              text: "Download glossary of abbreviations",
            },
          ],
          level: 2,
          text: "Summary",
        },
      ]

      expect(described_class.new(content_item).contents).to eq(expected_contents)
    end
  end

  describe "#show_finder_link?" do
    it "returns true when document type is statutory instrument" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "eu-withdrawal-act-2018-statutory-instruments")
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_finder_link?).to be true
    end

    it "returns false when document type is not a statutory instrument" do
      content_store_response = GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports")
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_finder_link?).to be false
    end
  end
end
