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

  describe "#display_metadata" do
    context "when facets are only mapped to one value" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }

      it "returns the details of the facets the content item is mapped to" do
        expected_display_metadata = {
          "Aircraft category" => ["<a href='/aaib-reports?aircraft_category%5B%5D=sport-aviation-and-balloons' class='govuk-link govuk-link--inverse'>Sport aviation and balloons</a>"],
          "Report type" => ["<a href='/aaib-reports?report_type%5B%5D=correspondence-investigation' class='govuk-link govuk-link--inverse'>Bulletin - Correspondence investigation</a>"],
          "Date of occurrence" => ["8 August 2015"],
          "Aircraft type" => ["Rotorsport UK Calidus"],
          "Location" => ["Damyns Hall Aerodrome, Essex"],
          "Registration" => %w[G-PCPC],
        }

        expect(described_class.new(content_store_response).display_metadata).to eq(expected_display_metadata)
      end
    end

    context "when a facet is mapped to multiple values" do
      let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "drug-device-alerts") }

      it "returns the details of all the facets the content item is mapped to" do
        expected_display_metadata = {
          "Alert type" => [
            "<a href='/drug-device-alerts?alert_type%5B%5D=devices' class='govuk-link govuk-link--inverse'>Medical device alert</a>",
          ],
          "Medical specialty" => [
            "<a href='/drug-device-alerts?medical_specialism%5B%5D=critical-care' class='govuk-link govuk-link--inverse'>Critical care</a>",
            "<a href='/drug-device-alerts?medical_specialism%5B%5D=general-practice' class='govuk-link govuk-link--inverse'>General practice</a>",
            "<a href='/drug-device-alerts?medical_specialism%5B%5D=obstetrics-gynaecology' class='govuk-link govuk-link--inverse'>Obstetrics and gynaecology</a>",
            "<a href='/drug-device-alerts?medical_specialism%5B%5D=paediatrics' class='govuk-link govuk-link--inverse'>Paediatrics</a>",
            "<a href='/drug-device-alerts?medical_specialism%5B%5D=theatre-practitioners' class='govuk-link govuk-link--inverse'>Theatre practitioners</a>",
          ],
          "Issued" => ["6 July 2015"],
        }

        expect(described_class.new(content_store_response).display_metadata).to eq(expected_display_metadata)
      end
    end
  end
end
