RSpec.describe "Body with image flexible section" do
  let(:flexible_section) { FlexiblePage::FlexibleSection::BodyWithImage.new(flexible_section_hash, nil) }
  let(:flexible_section_hash) do
    {
      "govspeak" => "<p class=\"govspeak\">Hello there!</p>",
      "image" => {
        "sources" => {
          "desktop" => "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
          "desktop_2x" => "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
          "mobile" => "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
          "mobile_2x" => "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
          "tablet" => "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
          "tablet_2x" => "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
        },
      },
    }
  end

  before do
    render(template: "flexible_page/flexible_sections/_body_with_image", locals: { flexible_section: })
  end

  describe "a body with image" do
    it "renders impact body with image section" do
      expect(rendered).to have_selector("[data-flexible-section='body-with-image']")
    end

    it "renders the text and image" do
      expect(rendered).to have_selector(".govspeak", text: "Hello there!")
      expect(rendered).to have_selector(".body-with-image__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']")
      expect(rendered).to have_selector(".body-with-image__image[alt='']")
    end
  end

  describe "an impact header without an image" do
    let(:flexible_section_hash) { { "govspeak" => "<p class=\"govspeak\">Hello there!</p>" } }

    it "renders impact body with image section" do
      expect(rendered).to have_selector("[data-flexible-section='body-with-image']")
    end

    it "renders the text but no image" do
      expect(rendered).to have_selector(".govspeak", text: "Hello there!")
      expect(rendered).not_to have_selector(".body-with-image__image")
    end
  end
end
