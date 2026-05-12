RSpec.describe FlexiblePage::FlexibleSection::Involved do
  subject(:involved) { described_class.new(organisations:) }

  let(:organisations) { orgs_data.map { |org_data| Organisation.new(org_data) } }
  let(:orgs_data) do
    [
      {
        "details" => {
          "brand" => "department-for-culture-media-sport",
          "logo" => {
            "crest" => "single-identity",
          },
        },
        "title" => "Department for Digital, Culture, Media & Sport",
        "web_url" => "https://www.gov.uk/government/organisations/department-for-digital-culture-media-sport",
      },
      {
        "details" => {
          "brand" => "ministry-of-defence",
          "logo" => {
            "image" => {
              "alt_text" => "Department for International Trade Defence & Security Organisation",
              "url" => "https://assets.publishing.service.gov.uk/media/59fa00e8ed915d7bfae58209/DIT_DSO_logo_banner.jpg",
            },
          },
        },
        "title" => "Department for International Trade Defence & Security Organisation",
        "web_url" => "https://www.gov.uk/government/organisations/department-for-international-trade-defence-and-security-organisation",
      },
    ]
  end

  describe "#organisation_data_for_components" do
    it "correctly converts data from the organisations array for use by the org logo component" do
      expect(involved.organisation_data_for_components).to eq([
        {
          name: "Department for Digital, Culture, Media & Sport",
          url: "https://www.gov.uk/government/organisations/department-for-digital-culture-media-sport",
          crest: "single-identity",
          brand: "department-for-culture-media-sport",
          image: nil,
        },
        {
          name: "Department for International Trade Defence & Security Organisation",
          url: "https://www.gov.uk/government/organisations/department-for-international-trade-defence-and-security-organisation",
          brand: "ministry-of-defence",
          crest: nil,
          image: {
            alt_text: "Department for International Trade Defence & Security Organisation",
            url: "https://assets.publishing.service.gov.uk/media/59fa00e8ed915d7bfae58209/DIT_DSO_logo_banner.jpg",
          },
        },
      ])
    end
  end
end
