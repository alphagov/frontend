RSpec.describe WorldwideCorporateInformationPagePresenter do
  let(:content_store_response) { GovukSchemas::Example.find("worldwide_corporate_information_page", example_name: "worldwide_corporate_information_page") }
  let(:content_item) { WorldwideCorporateInformationPage.new(content_store_response) }

  let(:presenter) { described_class.new(content_item) }

  it_behaves_like "it can have a contents list", "worldwide_corporate_information_page", "worldwide_corporate_information_page"

  it "returns an instance of WorldwideOrganisationPresenter" do
    expect(presenter.worldwide_organisation).to be_a(WorldwideOrganisationPresenter)
  end
end
