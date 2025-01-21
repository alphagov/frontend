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

  describe "#show_protection_type_image?" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names") }

    it "returns true if the document type is protected_food_drink_name and there is a protection type" do
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_protection_type_image?).to be true
    end

    it "returns false if the document type is not protected_food_drink_name" do
      content_store_response["document_type"] = "transaction"
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_protection_type_image?).to be false
    end

    it "returns false when there is no protection type" do
      content_store_response["details"]["metadata"]["protection_type"] = nil
      content_item = SpecialistDocument.new(content_store_response)

      expect(described_class.new(content_item).show_protection_type_image?).to be false
    end
  end

  describe "#protection_image_path" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names") }

    it "returns the full path to the protection image" do
      content_item = SpecialistDocument.new(content_store_response)
      expected_path = "specialist-documents/protected-food-drink-names/protected-designation-of-origin-pdo.png"

      expect(described_class.new(content_item).protection_image_path).to eq(expected_path)
    end
  end

  describe "#protection_image_alt_text" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names") }

    it "returns the alt text for the protection image" do
      content_item = SpecialistDocument.new(content_store_response)
      expected_alt_text = I18n.t("formats.specialist_document.protection_image.pdo_alt_text")

      expect(described_class.new(content_item).protection_image_alt_text).to eq(expected_alt_text)
    end
  end
end
