RSpec.describe WorldwideCorporateInformationPagePresenter do
  let(:content_item) { WorldwideCorporateInformationPage.new(GovukSchemas::Example.find("worldwide_corporate_information_page", example_name: "worldwide_corporate_information_page")) }

  let(:presenter) { described_class.new(content_item) }

  it "returns an instance of WorldwideOrganisationPresenter" do
    expect(presenter.worldwide_organisation).to be_a(WorldwideOrganisationPresenter)
  end
end
