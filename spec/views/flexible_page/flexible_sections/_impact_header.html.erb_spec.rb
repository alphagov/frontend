RSpec.describe "Impact header flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, title:) }

  let(:description) { "page description" }
  let(:image) { { sources: } }
  let(:title) { "page title" }

  let(:sources) do
    {
      desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
      desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
      mobile: "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
      mobile_2x: "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
      tablet: "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
      tablet_2x: "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
    }
  end

  let(:image_with_caption) { { caption: "My Caption", sources: } }

  before do
    render(template: "flexible_page/flexible_sections/_impact_header", locals: { flexible_section: })
  end

  it "renders impact header section" do
    expect(rendered).to have_selector(".app-c-impact-header .app-c-impact-header__container")
  end

  it "renders the text and image" do
    expect(rendered).to have_selector(".gem-c-heading", text: "page title")
    expect(rendered).to have_selector(".gem-c-lead-paragraph", text: "page description")
    expect(rendered).to have_selector(".app-c-impact-header__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']")
    expect(rendered).to have_selector(".app-c-impact-header__image[alt='']")
  end

  it "defaults to the plain variant" do
    expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--plain")
  end

  it "does not render a caption" do
    expect(rendered).not_to have_selector(".app-c-impact-header .gem-c-details")
  end

  context "without an image" do
    subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, title:) }

    it "renders the impact header section" do
      expect(rendered).to have_selector(".app-c-impact-header .app-c-impact-header__grid .govuk-grid-row")
    end

    it "does not render an image" do
      expect(rendered).not_to have_selector(".app-c-impact-header__image")
    end
  end

  context "when a caption is provided" do
    subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image: image_with_caption, title:) }

    it "renders a caption" do
      expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--plain .app-c-impact-header__caption")
      expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--plain .app-c-impact-header__caption .gem-c-details", text: "My Caption")
    end
  end

  context "with image_type set to logo" do
    subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, image_type: "logo", title:) }

    it "renders the logo layout" do
      expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--logo")
      expect(rendered).not_to have_selector(".app-c-impact-header--plain")
    end

    context "when the image has a caption" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image: image_with_caption, image_type: "logo", title:) }

      it "does not render a caption" do
        expect(rendered).not_to have_selector(".app-c-impact-header .gem-c-details")
      end
    end
  end

  context "with the variant set to govuk" do
    subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, title:, variant:) }

    let(:variant) { "govuk" }

    it "renders the govuk variant" do
      expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--govuk")
      expect(rendered).not_to have_selector(".app-c-impact-header--plain")
    end

    context "when a caption is provided" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image: image_with_caption, title:, variant:) }

      it "renders a caption" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--govuk .app-c-impact-header__caption")
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--govuk .app-c-impact-header__caption .gem-c-details")
      end
    end

    context "with image_type set to logo" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, image_type: "logo", title:, variant:) }

      it "renders the logo layout" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--logo.app-c-impact-header--govuk")
      end
    end

    context "with no image" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, title:, variant:) }

      it "renders the govuk variant" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--govuk")
      end
    end
  end

  context "with the variant set to notable-death" do
    subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, title:, variant:) }

    let(:variant) { "notable-death" }

    it "renders the notable-death variant" do
      expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--notable-death")
      expect(rendered).not_to have_selector(".app-c-impact-header--plain")
    end

    context "when a caption is provided" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image: image_with_caption, title:, variant:) }

      it "renders a caption" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--notable-death .app-c-impact-header__caption")
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--notable-death .app-c-impact-header__caption .gem-c-details")
      end
    end

    context "with image_type set to logo" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, image:, image_type: "logo", title:, variant:) }

      it "renders the logo layout" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--logo.app-c-impact-header--notable-death")
      end
    end

    context "with no image" do
      subject(:flexible_section) { FlexiblePage::FlexibleSection::ImpactHeader.new(description:, title:, variant:) }

      it "renders the notable-death variant" do
        expect(rendered).to have_selector(".app-c-impact-header.app-c-impact-header--notable-death")
      end
    end
  end
end
