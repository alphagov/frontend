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
    subject(:presenter) { described_class.new(content_item) }

    let(:content_item) { SpecialistDocument.new(content_store_response) }

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

    context "when the metadata contains an array of values that aren't filterable" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "returns the text for all values" do
        content_store_response["links"]["finder"][0]["details"]["facets"] = [
          {
            "key" => "alert_type",
            "name" => "Alert type",
            "type" => "text",
            "preposition" => "for",
            "display_as_result_metadata" => true,
            "filterable" => false,
            "allowed_values" => [
              {
                "label" => "Medical device alert",
                "value" => "devices",
              },
            ],
          },
        ]

        expected_metadata = {
          "Alert type" => ["Medical device alert"],
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end

    context "when the metadata contains subfacets" do
      let(:filterable) { false }
      let(:finder_base_path) { "/example-finder" }
      let(:content_item) { SpecialistDocument.new(content_store_response) }
      let(:content_store_response) do
        GovukSchemas::RandomExample.for_schema(frontend_schema: "specialist_document").tap do |payload|
          payload["details"]["metadata"] = {
            "nutrient-group" => "sugar",
            "sub-nutrient" => "refined-sugar",
          }
          payload["links"]["finder"] = [{
            "base_path" => finder_base_path,
            "details" => {
              "facets" => [
                {
                  "allowed_values" => [
                    {
                      "label" => "Sugar",
                      "value" => "sugar",
                      "sub_facets" => {
                        "label" => "Refined sugar",
                        "main_facet_label" => "Sugar",
                        "main_facet_value" => "sugar",
                        "value" => "refined-sugar",
                      },
                    },
                    {
                      "label" => "Carbohydrates",
                      "value" => "carbohydrates",
                    },
                  ],
                  "display_as_result_metadata" => true,
                  "filterable" => filterable,
                  "key" => "nutrient-group",
                  "name" => "Nutrient",
                  "preposition" => "Nutrient",
                  "short_name" => "Nutrient",
                  "sub_facet_key" => "sub-nutrient",
                  "sub_facet_name" => "Sub Nutrient",
                  "type" => "nested",
                },
              ],
            },
          }]
        end
      end

      it "returns the sub facet label with main facet label prefixed" do
        expected_metadata = {
          "Nutrient" => %w[Sugar],
          "Sub Nutrient" => ["Sugar - Refined sugar"],
        }
        expect(presenter.important_metadata).to include(expected_metadata)
      end

      context "and sub facets are filterable" do
        let(:filterable) { true }

        it "returns the sub facet link with both main facet and sub facet query params" do
          expected_metadata = {
            "Nutrient" => [
              "<a href='#{finder_base_path}?nutrient-group=sugar' class='govuk-link govuk-link--inverse'>Sugar</a>",
            ],
            "Sub Nutrient" => [
              "<a href='#{finder_base_path}?nutrient-group=sugar&sub-nutrient=refined-sugar' class='govuk-link govuk-link--inverse'>Sugar - Refined sugar</a>",
            ],
          }

          expect(presenter.important_metadata).to include(expected_metadata)
        end
      end
    end
  end
end
