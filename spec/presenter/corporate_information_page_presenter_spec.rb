RSpec.describe CorporateInformationPagePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }
  let(:content_item) { CorporateInformationPage.new(content_store_response) }

  it_behaves_like "it can have a contents list", "corporate_information_page", "corporate_information_page"

  describe "#additional_headers" do
    it "returns an array" do
      expect(presenter.additional_headers).to be_instance_of(Array)
    end

    context "when there are corporate information groups" do
      let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "best-practice-about-page") }

      it "includes the corporate information H2" do
        expected_additional_headers = [
          {
            "id" => "corporate-information",
            "level" => 2,
            "text" => "Corporate information",
          },
        ]

        expect(presenter.additional_headers).to eq(expected_additional_headers)
      end
    end

    context "when there are no corporate information groups available" do
      let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "best-practice-complaints-procedure") }

      it "returns an empty array" do
        expect(presenter.additional_headers).to eq([])
      end
    end
  end

  describe "#further_information" do
    context "when there are corporate information pages" do
      it "presents further information based on corporate information page links" do
        expect(presenter.further_information).to include("Publication scheme")
        expect(presenter.further_information).to include("/government/organisations/department-of-health/about/publication-scheme")
        expect(presenter.further_information).to include("Personal information charter")
        expect(presenter.further_information).to include("/government/organisations/department-of-health/about/personal-information-charter")
      end
    end

    context "when there are no corporate information pages" do
      let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page_without_description") }

      it "returns nil" do
        expect(presenter.further_information).to be_nil
      end
    end
  end
end
