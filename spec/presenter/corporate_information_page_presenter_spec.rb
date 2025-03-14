RSpec.describe CorporateInformationPagePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }
  let(:content_item) { CorporateInformationPage.new(content_store_response) }

  describe "#contents_list_headings" do
    it "includes the corporate information H2 if there are corporate information groups available" do
      corporate_information_heading = { text: "Corporate information", id: "corporate-information", href: "#corporate-information" }

      expect(presenter.contents_list_headings.last).to eq(corporate_information_heading)
    end
  end

  describe "#corporate_information_heading" do
    it "returns the heading title" do
      expect(presenter.corporate_information_heading[:text]).to eq("Corporate information")
    end

    it "returns the heading id" do
      expect(presenter.corporate_information_heading[:id]).to eq("corporate-information")
    end

    it "returns the heading as an anchor link" do
      expect(presenter.corporate_information_heading[:href]).to eq("#corporate-information")
    end
  end

  describe "#further_information" do
    it "presents further information based on corporate information page links" do
      expect(presenter.further_information).to include("Publication scheme")
      expect(presenter.further_information).to include("/government/organisations/department-of-health/about/publication-scheme")
      expect(presenter.further_information).to include("Personal information charter")
      expect(presenter.further_information).to include("/government/organisations/department-of-health/about/personal-information-charter")
    end
  end
end
