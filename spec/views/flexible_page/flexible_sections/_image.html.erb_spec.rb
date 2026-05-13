RSpec.describe "Image flexible section" do
  subject(:flexible_section) { FlexiblePage::FlexibleSection::Image.new(image: image_params) }

  let(:image_params) do
    {
      caption: "Hello!",
      sources: {
        desktop: "https://test.gov.uk/desktop.png",
        desktop_2x: "https://test.gov.uk/desktop_2x.png",
        tablet: "https://test.gov.uk/tablet.png",
        tablet_2x: "https://test.gov.uk/tablet_2x.png",
        mobile: "https://test.gov.uk/mobile.png",
        mobile_2x: "https://test.gov.uk/mobile_2x.png",
      },
    }
  end

  before do
    render(template: "flexible_page/flexible_sections/_image", locals: { flexible_section: })
  end

  it "renders impact body with image section" do
    expect(rendered).to have_selector(".body-with-image__image-wrapper")
  end
end
