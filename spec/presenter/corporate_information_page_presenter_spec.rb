RSpec.describe CorporateInformationPagePresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page") }
  let(:content_item) { CorporateInformationPage.new(content_store_response) }

  describe "#contents_list_headings" do
    it "returns an instance of ContentsOutline" do
      expect(presenter.contents_list_headings).to be_instance_of(ContentsOutline)
    end

    it "includes the corporate information H2 at the end of the contents list if there are corporate information groups available" do
      contents_list_headings = presenter.contents_list_headings
      corporate_information_heading = contents_list_headings.items.last

      expect(corporate_information_heading.text).to eq("Corporate information")
      expect(corporate_information_heading.id).to eq("corporate-information")
      expect(corporate_information_heading.level).to eq(2)
      expect(contents_list_headings.items.count).to eq(5)
    end
  end

  describe "#corporate_information_heading" do
    it "returns the heading title" do
      expect(presenter.corporate_information_heading["text"]).to eq("Corporate information")
    end

    it "returns the heading id" do
      expect(presenter.corporate_information_heading["id"]).to eq("corporate-information")
    end

    it "returns the heading level as H@" do
      expect(presenter.corporate_information_heading["level"]).to eq(2)
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
