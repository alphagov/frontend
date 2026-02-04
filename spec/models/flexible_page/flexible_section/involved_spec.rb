RSpec.describe FlexiblePage::FlexibleSection::Involved do
  organisations = {
    "organisations" => [
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
    ],
  }

  let(:involved) { described_class.new(organisations, FlexiblePage.new({})) }

  describe "#format_data_for_components" do
    it "correctly converts data from the content item for use by the org logo component" do
      expect(involved.organisations).to eq([
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
