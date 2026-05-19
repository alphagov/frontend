RSpec.describe FlexiblePage::FlexibleSection::Image do
  subject(:image) { described_class.new(image: image_params) }

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

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(image.image).to eq(image_params)
    end
  end
end
