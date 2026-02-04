RSpec.describe "Involved flexible section" do
  let(:flexible_section) do
    FlexiblePage::FlexibleSection::Involved.new(
      {
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
                "crest" => "custom",
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
      },
      nil,
    )
  end

  before do
    render(template: "flexible_page/flexible_sections/_involved", locals: { flexible_section: })
  end

  it "renders involved section" do
    expect(rendered).to have_selector("[data-flexible-section='involved']")
  end

  it "renders the relevant organisations" do
    expect(rendered).to have_selector(".gem-c-organisation-logo.brand--department-for-culture-media-sport", text: "Department for Digital, Culture, Media & Sport")
    expect(rendered).to have_selector(".gem-c-organisation-logo.brand--ministry-of-defence")
    expect(rendered).to have_selector(".gem-c-organisation-logo__image[alt='Department for International Trade Defence & Security Organisation'][src='https://assets.publishing.service.gov.uk/media/59fa00e8ed915d7bfae58209/DIT_DSO_logo_banner.jpg']")
  end
end
