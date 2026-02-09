RSpec.describe "Impact header flexible section" do
  let(:flexible_section) do
    FlexiblePage::FlexibleSection::ImpactHeader.new(
      {
        "title" => "page title",
        "description" => "page description",
        "image" => {
          "alt_text" => "image alt text",
          "sources" => {
            "desktop" => "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
            "desktop_2x" => "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
            "mobile" => "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
            "mobile_2x" => "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
            "tablet" => "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
            "tablet_2x" => "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
          },
        },
      },
      nil,
    )
  end

  let(:flexible_section_without_image) do
    FlexiblePage::FlexibleSection::ImpactHeader.new(
      {
        "title" => "page title",
        "description" => "page description",
      },
      nil,
    )
  end

  describe "an impact header" do
    before do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: })
    end

    it "renders impact header section" do
      expect(rendered).to have_selector("[data-flexible-section='impact-header']")
      expect(rendered).to have_selector(".impact-header .impact-header__container")
    end

    it "renders the text and image" do
      expect(rendered).to have_selector(".gem-c-heading", text: "page title")
      expect(rendered).to have_selector(".gem-c-lead-paragraph", text: "page description")
      expect(rendered).to have_selector(".impact-header__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']")
    end
  end

  describe "an impact header without an image" do
    before do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: flexible_section_without_image })
    end

    it "renders impact header section" do
      expect(rendered).to have_selector("[data-flexible-section='impact-header']")
      expect(rendered).to have_selector(".impact-header.impact-header--grid .govuk-grid-row")
    end

    it "does not include an image" do
      expect(rendered).not_to have_selector(".impact-header__image")
    end
  end
end
