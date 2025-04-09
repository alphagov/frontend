RSpec.describe SpecialistDocument do
  it_behaves_like "it has updates", "specialist_document", "cma-cases-with-change-history"
  it_behaves_like "it has no updates", "specialist_document", "cma-cases"

  describe "#headers" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }
    let(:details_headers) do
      [
        {
          "text" => "Summary:",
          "level" => 2,
          "id" => "summary",
          "headers" => [
            {
              "text" => "Download report:",
              "level" => 3,
              "id" => "download-report",
            },
            {
              "text" => "Download glossary of abbreviations:",
              "level" => 3,
              "id" => "download-glossary-of-abbreviations",
            },
          ],
        },
      ]
    end

    it "gets a list of headers" do
      content_store_response["details"]["headers"] = details_headers
      expected_headers = [
        {
          href: "#summary",
          text: "Summary",
          level: 2,
          items: [
            {
              href: "#download-report",
              text: "Download report",
              level: 3,
            },
            {
              href: "#download-glossary-of-abbreviations",
              text: "Download glossary of abbreviations",
              level: 3,
            },
          ],
        },
      ]

      expect(described_class.new(content_store_response).headers).to eq(expected_headers)
    end
  end

  context "with links to an external site" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "business-finance-support-scheme") }

    describe "#continuation_link" do
      it "gets the continuation link" do
        expected_continuation_link = content_store_response["details"]["metadata"]["continuation_link"]
        expect(described_class.new(content_store_response).continuation_link).to eq(expected_continuation_link)
      end
    end

    describe "#will_continue_on" do
      it "gets the continuation link text" do
        expected_will_continue_on = content_store_response["details"]["metadata"]["will_continue_on"]
        expect(described_class.new(content_store_response).will_continue_on).to eq(expected_will_continue_on)
      end
    end
  end

  describe "protection type images" do
    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "protected-food-drink-names") }

    context "when a protection type exists and is known" do
      it "gets the image details" do
        content_store_response["details"]["metadata"]["protection_type"] = "protected-designation-of-origin-pdo"
        expected = {
          "file_name" => "protected-designation-of-origin-pdo.png",
          "alt_text_tag" => "pdo_alt_text",
        }

        expect(described_class.new(content_store_response).protection_type_image).to eq(expected)
      end
    end

    context "when a protection type exists but is not recognised" do
      it "returns nil" do
        content_store_response["details"]["metadata"]["protection_type"] = "fake-type"

        expect(described_class.new(content_store_response).protection_type_image).to be_nil
      end
    end

    context "when a protection type does not exist" do
      it "returns nil" do
        content_store_response["details"]["metadata"]["protection_type"] = nil

        expect(described_class.new(content_store_response).protection_type_image).to be_nil
      end
    end
  end

  describe "#facets_with_values_from_metadata" do
    context "when facets are mapped to non-existing value" do
      let(:content_store_response) do
        GovukSchemas::RandomExample.for_schema(frontend_schema: "specialist_document").tap do |payload|
          payload["details"]["metadata"] = {
            "game" => "mario",
          }
          payload["links"]["finder"] = [{ "details" => {
            "facets" => [{
              "allowed_values" => [
                {
                  "label" => "Donkey Kong",
                  "value" => "donkey-kong",
                },
                {
                  "label" => "Zelda",
                  "value" => "zelda",
                },
              ],
              "display_as_result_metadata" => true,
              "filterable" => true,
              "key" => "game",
              "name" => "Game",
              "preposition" => "Game",
              "short_name" => "Game",
              "type" => "text",
            }],
          } }]
        end
      end

      it "returns the facet but without the values" do
        expected_facet_values = [{
          key: "game",
          name: "Game",
          type: "link",
          value: [],
        }]
        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facet_values)
      end
    end

    context "when facets are mapped to non-text value" do
      let(:filterable) { true }
      let(:content_store_response) do
        GovukSchemas::RandomExample.for_schema(frontend_schema: "specialist_document").tap do |payload|
          payload["details"]["metadata"] = {
            "date" => "2020-01-03",
          }
          payload["links"]["finder"] = [{ "details" => {
            "facets" => [{
              "display_as_result_metadata" => true,
              "filterable" => filterable,
              "key" => "date",
              "name" => "Date",
              "preposition" => "Date",
              "short_name" => "Date",
              "type" => "date",
            }],
          } }]
        end
      end

      it "returns the facet and type" do
        expected_facet_values = [{
          key: "date",
          name: "Date",
          type: "date",
          value: "2020-01-03",
        }]
        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facet_values)
      end
    end

    context "when facets are only mapped to one value" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }

      it "returns the details of the facets the content item is mapped to" do
        expected_facet_values = [
          {
            key: "aircraft_category",
            name: "Aircraft category",
            type: "link",
            value: [{
              label: "Sport aviation and balloons",
              value: "sport-aviation-and-balloons",
            }],
          },
          {
            key: "report_type",
            name: "Report type",
            type: "link",
            value: [{
              label: "Bulletin - Correspondence investigation",
              value: "correspondence-investigation",
            }],
          },
          {
            key: "date_of_occurrence",
            name: "Date of occurrence",
            type: "date",
            value: "2015-08-08",
          },
          {
            key: "aircraft_type",
            name: "Aircraft type",
            type: "text",
            value: "Rotorsport UK Calidus",
          },
          {
            key: "location",
            name: "Location",
            type: "text",
            value: "Damyns Hall Aerodrome, Essex",
          },
          {
            key: "registration",
            name: "Registration",
            type: "text",
            value: "G-PCPC",
          },
        ]

        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facet_values)
      end
    end

    context "when a facet is mapped to multiple values" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "returns the details of all the facets the content item is mapped to" do
        expected_facet_values = [
          {
            key: "alert_type",
            name: "Alert type",
            type: "link",
            value: [{
              label: "Medical device alert",
              value: "devices",
            }],
          },
          {
            key: "medical_specialism",
            name: "Medical specialty",
            type: "link",
            value: [
              {
                label: "Critical care",
                value: "critical-care",
              },
              {
                label: "General practice",
                value: "general-practice",
              },
              {
                label: "Obstetrics and gynaecology",
                value: "obstetrics-gynaecology",
              },
              {
                label: "Paediatrics",
                value: "paediatrics",
              },
              {
                label: "Theatre practitioners",
                value: "theatre-practitioners",
              },
            ],
          },
          {
            key: "issued_date",
            name: "Issued",
            type: "date",
            value: "2015-07-06",
          },
        ]
        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facet_values)
      end
    end

    context "when a facet can be mapped to one of many non-filterable values" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "returns the details of all the facets the content item is mapped to" do
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

        expected_facet_values = {
          key: "alert_type",
          name: "Alert type",
          type: "preset_text",
          value: [{
            label: "Medical device alert",
            value: "devices",
          }],
        }

        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to include(expected_facet_values)
      end
    end

    context "when there are sub facets" do
      let(:filterable) { true }
      let(:content_store_response) do
        GovukSchemas::RandomExample.for_schema(frontend_schema: "specialist_document").tap do |payload|
          payload["details"]["metadata"] = {
            "nutrient-group" => "sugar",
            "sub-nutrient" => "refined-sugar",
          }
          payload["links"]["finder"] = [{ "details" => {
            "facets" => [{
              "allowed_values" => [
                {
                  "label" => "Sugar",
                  "value" => "sugar",
                  "sub_facets" => [
                    {
                      "label" => "Refined sugar",
                      "main_facet_label" => "Sugar",
                      "main_facet_value" => "sugar",
                      "value" => "refined-sugar",
                    },
                  ],
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
            }],
          } }]
        end
      end

      it "returns link sub facet details as well as main facet label, value, and key" do
        expected_facets = [
          {
            key: "nutrient-group",
            name: "Nutrient",
            type: "link",
            value: [{
              label: "Sugar",
              value: "sugar",
            }],
          },
          {
            key: "sub-nutrient",
            name: "Sub Nutrient",
            main_facet_key: "nutrient-group",
            type: "sub_facet_link",
            value: [
              {
                label: "Refined sugar",
                value: "refined-sugar",
                main_facet_label: "Sugar",
                main_facet_value: "sugar",
              },
            ],
          },
        ]

        expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facets)
      end

      context "and is not filterable" do
        let(:filterable) { false }

        it "returns text sub facet details as well as main facet label, value, and key" do
          expected_facets = [
            {
              key: "nutrient-group",
              name: "Nutrient",
              type: "preset_text",
              value: [{
                label: "Sugar",
                value: "sugar",
              }],
            },
            {
              key: "sub-nutrient",
              name: "Sub Nutrient",
              main_facet_key: "nutrient-group",
              type: "sub_facet_text",
              value: [
                {
                  label: "Refined sugar",
                  value: "refined-sugar",
                  main_facet_label: "Sugar",
                  main_facet_value: "sugar",
                },
              ],
            },
          ]

          expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facets)
        end
      end

      context "and type is not nested" do
        let(:content_store_response) do
          GovukSchemas::RandomExample.for_schema(frontend_schema: "specialist_document").tap do |payload|
            payload["details"]["metadata"] = {
              "nutrient-group" => "sugar",
              "sub-nutrient" => "refined-sugar",
            }
            payload["links"]["finder"] = [{ "details" => {
              "facets" => [{
                "allowed_values" => [
                  {
                    "label" => "Sugar",
                    "value" => "sugar",
                    "sub_facets" => [
                      {
                        "label" => "Refined sugar",
                        "main_facet_label" => "Sugar",
                        "main_facet_value" => "sugar",
                        "value" => "refined-sugar",
                      },
                    ],
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
                "type" => "something-else",
              }],
            } }]
          end
        end

        it "does not return the sub-facet" do
          expected_facets = [
            {
              key: "nutrient-group",
              name: "Nutrient",
              type: "something-else",
              value: [{
                label: "Sugar",
                value: "sugar",
              }],
            },
          ]

          expect(described_class.new(content_store_response).facets_with_values_from_metadata).to eq(expected_facets)
        end
      end
    end
  end
end
