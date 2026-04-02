RSpec.describe "Impact header flexible section" do
  def create_data(include_image = nil, variant = nil, logo = nil, caption = nil)
    data = {
      "title" => "page title",
      "description" => "page description",
    }
    image = {
      "sources" => {
        "desktop" => "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
        "desktop_2x" => "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
        "mobile" => "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
        "mobile_2x" => "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
        "tablet" => "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
        "tablet_2x" => "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
      },
    }

    data["image"] = image if include_image
    data["variant"] = variant if variant
    data["image_type"] = logo ? "logo" : "header"
    data["image"]["caption"] = "Test data" if caption && include_image
    FlexiblePage::FlexibleSection::ImpactHeader.new(data, nil)
  end

  describe "an impact header" do
    before do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true) })
    end

    it "renders impact header section" do
      expect(rendered).to have_selector("[data-flexible-section='impact-header']")
      expect(rendered).to have_selector(".impact-header .impact-header__container")
    end

    it "renders the text and image" do
      expect(rendered).to have_selector(".gem-c-heading", text: "page title")
      expect(rendered).to have_selector(".gem-c-lead-paragraph", text: "page description")
      expect(rendered).to have_selector(".impact-header__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']")
      expect(rendered).to have_selector(".impact-header__image[alt='']")
    end
  end

  describe "an impact header without an image" do
    before do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data })
    end

    it "renders the impact header section" do
      expect(rendered).to have_selector("[data-flexible-section='impact-header']")
      expect(rendered).to have_selector(".impact-header .impact-header__grid .govuk-grid-row")
    end

    it "does not include an image" do
      expect(rendered).not_to have_selector(".impact-header__image")
    end
  end

  describe "variations" do
    it "defaults to the plain variant" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true) })
      expect(rendered).to have_selector(".impact-header.impact-header--plain")
    end

    it "can render a caption on the plain variant" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, nil, nil, true) })
      expect(rendered).to have_selector(".impact-header.impact-header--plain")
      expect(rendered).to have_selector(".impact-header.impact-header--plain .impact-header__caption")
      expect(rendered).to have_selector(".impact-header.impact-header--plain .impact-header__caption .gem-c-details")
    end

    it "does not default to the plain variant if logo layout" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, nil, true) })
      expect(rendered).to have_selector(".impact-header.impact-header--logo")
      expect(rendered).not_to have_selector(".impact-header--plain")
    end

    it "can render the govuk variant" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, "govuk") })
      expect(rendered).to have_selector(".impact-header.impact-header--govuk")
    end

    it "can render the govuk variant with a caption" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, "govuk", nil, true) })
      expect(rendered).to have_selector(".impact-header.impact-header--govuk .impact-header__caption")
      expect(rendered).to have_selector(".impact-header.impact-header--govuk .impact-header__caption .gem-c-details")
    end

    it "can render the notable-death variant" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, "notable-death") })
      expect(rendered).to have_selector(".impact-header.impact-header--notable-death")
    end

    it "can render the notable-death variant with a caption" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(true, "notable-death", nil, true) })
      expect(rendered).to have_selector(".impact-header.impact-header--notable-death .impact-header__caption")
      expect(rendered).to have_selector(".impact-header.impact-header--notable-death .impact-header__caption .gem-c-details")
    end

    it "can render a logo layout with a background variant" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(nil, "govuk", true) })
      expect(rendered).to have_selector(".impact-header.impact-header--logo.impact-header--govuk")
      expect(rendered).not_to have_selector(".impact-header--plain")
    end

    it "has no caption on the logo layout" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(nil, "govuk", true, true) })
      expect(rendered).not_to have_selector(".impact-header.impact-header--logo .impact-header__caption")
      expect(rendered).not_to have_selector(".impact-header.impact-header--logo .impact-header__caption .gem-c-details")
    end

    it "can render a variant when there is no image" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(nil, "notable-death") })
      expect(rendered).to have_selector(".impact-header.impact-header--notable-death")
    end

    it "has no caption when there is no image" do
      render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: create_data(nil, "notable-death", nil, true) })
      expect(rendered).not_to have_selector(".impact-header.impact-header--notable-death .impact-header__caption")
      expect(rendered).not_to have_selector(".impact-header.impact-header--notable-death .impact-header__caption .gem-c-details")
    end
  end
end
