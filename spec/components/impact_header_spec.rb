RSpec.describe "ImpactheaderComponent", type: :view do
  def component_name
    "impact_header"
  end

  heading = "page heading"
  description = "page description"
  image = {
    sources: {
      desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
      desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
      mobile: "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
      mobile_2x: "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
      tablet: "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
      tablet_2x: "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
    },
  }
  image_with_caption = {
    caption: "this is a caption",
    sources: {
      desktop: "https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg",
      desktop_2x: "https://assets.publishing.service.gov.uk/media/67472570cf0d45234dd8d0a8/hero_desktop_2x_F_Desktop_HD-50.jpg",
      mobile: "https://assets.publishing.service.gov.uk/media/67472591a72d7eb7f348c047/hero_mobile_1x_F_MOBILE_HD-50.jpg",
      mobile_2x: "https://assets.publishing.service.gov.uk/media/674725912f94bef8ff48c044/hero_mobile_2x_F_MOBILE_HD-50.jpg",
      tablet: "https://assets.publishing.service.gov.uk/media/6747258077462f78091474e2/hero_tablet_1x_F_Tablet_HD-50.jpg",
      tablet_2x: "https://assets.publishing.service.gov.uk/media/67472580886c31e352d8d0b1/hero_tablet_2x_F_Tablet_HD-50.jpg",
    },
  }

  it "renders nothing without config" do
    render_component({})
    assert_empty render_component({})
  end

  it "renders a basic impact header with only a heading" do
    render_component({ heading: heading })
    assert_select ".app-c-impact-header.app-c-impact-header--plain"
    assert_select ".app-c-impact-header .gem-c-details", false
  end

  it "renders the component with heading and description" do
    render_component({ heading: heading, description: description })
    assert_select ".gem-c-heading", text: "page heading"
    assert_select ".gem-c-lead-paragraph", text: "page description"
  end

  it "uses the govuk-grid layout when there is no image" do
    render_component({ heading: heading, description: description })
    assert_select ".app-c-impact-header .app-c-impact-header__grid .govuk-grid-row"
    assert_select ".app-c-impact-header__image", false
  end

  it "renders the component with an image" do
    render_component({ heading: heading, image: image })
    assert_select ".app-c-impact-header__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']"
    assert_select ".app-c-impact-header__image[alt='']"
    assert_select ".app-c-impact-header .app-c-impact-header__caption", false
  end

  it "renders the component with an image and caption" do
    render_component({ heading: heading, image: image_with_caption })
    assert_select ".app-c-impact-header__image[src='https://assets.publishing.service.gov.uk/media/674725702f94bef8ff48c043/hero_desktop_1x_F_Desktop_HD-50.jpg']"
    assert_select ".app-c-impact-header__image[alt='']"
    assert_select ".app-c-impact-header .app-c-impact-header__caption"
    assert_select ".app-c-impact-header .app-c-impact-header__caption .gem-c-details .govuk-details__text", text: "this is a caption"
  end

  it "renders the logo layout" do
    render_component({ heading: heading, image_type: "logo", image: image })
    assert_select ".app-c-impact-header.app-c-impact-header--logo"
    assert_select ".app-c-impact-header--plain", false
  end

  it "does not show a caption logo layout even if one exists" do
    render_component({ heading: heading, image_type: "logo", image: image_with_caption })
    assert_select ".app-c-impact-header.app-c-impact-header--logo"
    assert_select ".app-c-impact-header--plain", false
    assert_select ".app-c-impact-header .app-c-impact-header__caption", false
  end

  it "renders the GOVUK variant" do
    render_component({ heading: heading, image: image_with_caption, variant: "govuk" })
    assert_select ".app-c-impact-header.app-c-impact-header--govuk"
    assert_select ".impact-header--plain", false
    assert_select ".app-c-impact-header.app-c-impact-header--govuk .app-c-impact-header__caption"
    assert_select ".app-c-impact-header.app-c-impact-header--govuk .app-c-impact-header__caption .gem-c-details"
  end

  it "renders the GOVUK variant with the logo layout" do
    render_component({ heading: heading, image_type: "logo", image: image, variant: "govuk" })
    assert_select ".app-c-impact-header.app-c-impact-header--logo.app-c-impact-header--govuk"
    assert_select ".impact-header--plain", false
  end

  it "renders the notable death variant" do
    render_component({ heading: heading, image: image_with_caption, variant: "notable-death" })
    assert_select ".app-c-impact-header.app-c-impact-header--notable-death"
    assert_select ".impact-header--plain", false
    assert_select ".app-c-impact-header.app-c-impact-header--notable-death .app-c-impact-header__caption"
    assert_select ".app-c-impact-header.app-c-impact-header--notable-death .app-c-impact-header__caption .gem-c-details.gem-c-details--inverse"
  end
end
