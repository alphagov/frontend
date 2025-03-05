RSpec.describe SpecialistDocument do
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

    it_behaves_like "it has updates", "specialist_document", "cma-cases-with-change-history"
    it_behaves_like "it has no updates", "specialist_document", "cma-cases"

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

  describe "#facet_values" do
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

        expect(described_class.new(content_store_response).facet_values).to eq(expected_facet_values)
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
        expect(described_class.new(content_store_response).facet_values).to eq(expected_facet_values)
      end
    end

    context "when there are nested facets" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "trademark-decision-with-nested-facets") }

      it "returns the details of all the sub-facets the content item is mapped to" do
        expected_facet_values = [
          {
            key: "trademark_decision_british_library_number",
            name: "British Library number",
            value: "BL2345678",
            type: "text",
          },
          {
            key: "trademark_decision_type_of_hearing",
            name: "Type of hearing",
            value: [
              {
                label: "Registrar – Ex parte hearings",
                value: "registrar-ex-parte-hearings",
              },
            ],
            type: "link",
          },
          {
            key: "trademark_decision_class",
            name: "Class",
            value: [
              {
                label: "3",
                value: "3",
              },
            ],
            type: "link",
          },
          {
            key: "trademark_decision_date",
            name: "Decision date",
            value: "2020-01-01",
            type: "date",
          },
          {
            key: "trademark_decision_appointed_person_hearing_officer",
            name: "Appointed person/hearing officer",
            value: [
              {
                label: "Ms L Adams",
                value: "ms-l-adams",
              },
            ],
            type: "link",
          },
          {
            key: "trademark_decision_grounds_section",
            name: "Grounds Section",
            value: [
              {
                label: "Section 3(1) Graphical Representation",
                value: "section-3-1-graphical-representation",
              },
              {
                label: "Section 3(1) Descriptiveness/Distinctiveness",
                value: "section-3-1-descriptiveness-distinctiveness",
              },
              {
                label: "Section 3(6) Bad Faith",
                value: "section-3-6-bad-faith",
              },
              {
                label: "Section 5(1), 5(2) and 5(3) Earlier Trade Marks",
                value: "section-5-1-5-2-and-5-3-earlier-trade-marks",
              },
            ],
            type: "link",
          },
          {
            key: "trademark_decision_grounds_sub_section",
            name: "Grounds Sub Section",
            value: [
              {
                label: "Not Applicable",
                value: "section-3-1-graphical-representation-not-applicable",
                main_facet_label: "Section 3(1) Graphical Representation",
                main_facet_value: "section-3-1-graphical-representation",
              },
              {
                label: "Customary in the language etc. - trade name for goods or services",
                value: "section-3-1-descriptiveness-distinctiveness-customary-in-the-language-etc-trade-name-for-goods-or-services",
                main_facet_label: "Section 3(1) Descriptiveness/Distinctiveness",
                main_facet_value: "section-3-1-descriptiveness-distinctiveness",
              },
              {
                label: "Breakdown of former business relationship",
                value: "section-3-6-bad-faith-breakdown-of-former-business-relationship",
                main_facet_label: "Section 3(6) Bad Faith",
                main_facet_value: "section-3-6-bad-faith",
              },
              {
                label: "Composite word and device marks",
                value: "section-5-1-5-2-and-5-3-earlier-trade-marks-composite-word-and-device-marks",
                main_facet_label: "Section 5(1), 5(2) and 5(3) Earlier Trade Marks",
                main_facet_value: "section-5-1-5-2-and-5-3-earlier-trade-marks",
              },
            ],
            type: "link",
          },
        ]

        expect(described_class.new(content_store_response).facet_values).to eq(expected_facet_values)
      end
    end
  end
end
