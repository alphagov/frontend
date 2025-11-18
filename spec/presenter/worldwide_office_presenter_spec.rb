RSpec.describe WorldwideOfficePresenter do
  let(:content_item) { WorldwideOffice.new(GovukSchemas::Example.find("worldwide_office", example_name: "worldwide_office")) }

  let(:presenter){ described_class.new(content_item) }

  it "#body returns the access and opening times of the schema item" do
    expect(content_item.content_store_response["details"]["access_and_opening_times"]).to eq(presenter.body)
  end

  it "#contact returns the contact as an instance of #{LinkedContactPresenter}" do
    expect(presenter.contact).to be_a(LinkedContactPresenter)
  end

  it "#worldwide_organisation returns as an instance of #{WorldwideOrganisationPresenter}" do
    expect(presenter.worldwide_organisation).to be_a(WorldwideOrganisationPresenter)
  end
end
