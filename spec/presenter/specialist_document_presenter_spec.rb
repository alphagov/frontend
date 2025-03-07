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

  describe "#important_metadata" do
    subject(:presenter) { described_class.new(content_item, view_context) }

    let(:content_item) { SpecialistDocument.new(content_store_response) }
    let(:view_context) { ApplicationController.new.view_context }

    context "when the metadata contains text" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }

      it "returns the value of the metadata" do
        expected_metadata = {
          "Aircraft type" => "Rotorsport UK Calidus",
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end

    context "when the metadata contains dates" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "returns facet metadata with formatted dates" do
        expected_metadata = { "Issued" => "6 July 2015" }
        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end

    context "when the metadata contains an array of values" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "formats the links for all values" do
        expected_metadata = {
          "Medical specialty" => [
            "<a href='/drug-device-alerts?medical_specialism=critical-care' class='govuk-link govuk-link--inverse'>Critical care</a>",
            "<a href='/drug-device-alerts?medical_specialism=general-practice' class='govuk-link govuk-link--inverse'>General practice</a>",
            "<a href='/drug-device-alerts?medical_specialism=obstetrics-gynaecology' class='govuk-link govuk-link--inverse'>Obstetrics and gynaecology</a>",
            "<a href='/drug-device-alerts?medical_specialism=paediatrics' class='govuk-link govuk-link--inverse'>Paediatrics</a>",
            "<a href='/drug-device-alerts?medical_specialism=theatre-practitioners' class='govuk-link govuk-link--inverse'>Theatre practitioners</a>",
          ],
        }
        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end

    context "when the metadata contains nested facets" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "trademark-decision-with-nested-facets") }

      it "displays the metadata for the parent facet" do
        expected_metadata = {
          "Grounds Section" => [
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-1-graphical-representation' class='govuk-link govuk-link--inverse'>Section 3(1) Graphical Representation</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-1-descriptiveness-distinctiveness' class='govuk-link govuk-link--inverse'>Section 3(1) Descriptiveness/Distinctiveness</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-6-bad-faith' class='govuk-link govuk-link--inverse'>Section 3(6) Bad Faith</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-5-1-5-2-and-5-3-earlier-trade-marks' class='govuk-link govuk-link--inverse'>Section 5(1), 5(2) and 5(3) Earlier Trade Marks</a>",
          ],
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end

      it "displays the metadata for the child facet" do
        expected_metadata = {
          "Grounds Sub Section" => [
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-1-graphical-representation&trademark_decision_grounds_sub_section=section-3-1-graphical-representation-not-applicable' class='govuk-link govuk-link--inverse'>Section 3(1) Graphical Representation - Not Applicable</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-1-descriptiveness-distinctiveness&trademark_decision_grounds_sub_section=section-3-1-descriptiveness-distinctiveness-customary-in-the-language-etc-trade-name-for-goods-or-services' class='govuk-link govuk-link--inverse'>Section 3(1) Descriptiveness/Distinctiveness - Customary in the language etc. - trade name for goods or services</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-3-6-bad-faith&trademark_decision_grounds_sub_section=section-3-6-bad-faith-breakdown-of-former-business-relationship' class='govuk-link govuk-link--inverse'>Section 3(6) Bad Faith - Breakdown of former business relationship</a>",
            "<a href='/trademark-decisions?trademark_decision_grounds_section=section-5-1-5-2-and-5-3-earlier-trade-marks&trademark_decision_grounds_sub_section=section-5-1-5-2-and-5-3-earlier-trade-marks-composite-word-and-device-marks' class='govuk-link govuk-link--inverse'>Section 5(1), 5(2) and 5(3) Earlier Trade Marks - Composite word and device marks</a>",
          ],
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end
  end
end
