RSpec.describe OrganisationLogo do
  let(:logo) do
    {
      "crest" => "dbt",
      "formatted_title" => "Department for<br/>Business &amp; Trade",
    }
  end

  let(:url) { "/government/organisations/department-for-business-trade" }

  describe "#url" do
    it "gets the url" do
      expect(described_class.new(logo, url).url)
      .to eq("/government/organisations/department-for-business-trade")
    end
  end
end
