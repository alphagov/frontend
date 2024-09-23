RSpec.describe "Meta Tags" do
  before do
    case_study = GovukSchemas::RandomExample.for_schema(frontend_schema: "take_part") do |random|
      random.merge!(
        "title" => "Zhe title",
        "withdrawn_notice" => {},
      )
      random["links"]["available_translations"] = []
      random
    end

    stub_content_store_has_item("/government/get-involved/take-part/some-page", case_study.to_json)
  end

  it "renders the correct meta tags for pages" do
    visit "/government/get-involved/take-part/some-page"

    expect(page).to have_css("meta[property='og:title'][content='Zhe title']", visible: false)
  end

  context "for pages with images" do
    before do
      case_study = GovukSchemas::RandomExample.for_schema(frontend_schema: "take_part") do |random|
        random["details"] = random["details"].merge(
          "image" => {
            "url" => "https://example.org/image.jpg",
            "alt_text" => "An accessible alt text",
          },
        )
        random["links"]["available_translations"] = []
        random
      end

      stub_content_store_has_item("/government/get-involved/take-part/some-page", case_study.to_json)
    end

    it "renders image tags" do
      visit "/government/get-involved/take-part/some-page"

      expect(page).to have_css("meta[name='twitter:card'][content='summary_large_image']", visible: false)
      expect(page).to have_css("meta[name='twitter:image'][content='https://example.org/image.jpg']", visible: false)
      expect(page).to have_css("meta[property='og:image'][content='https://example.org/image.jpg']", visible: false)
    end
  end
end
