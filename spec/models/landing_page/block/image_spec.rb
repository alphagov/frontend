RSpec.describe LandingPage::Block::Image do
  subject(:image) { described_class.new(blocks_hash, build(:landing_page)) }

  let(:blocks_hash) do
    { "type" => "image",
      "image" => {
        "alt" => "some alt text",
        "sources" => {
          "desktop" => "landing_page/desktop.jpeg",
          "desktop_2x" => "landing_page/desktop_2x.jpeg",
          "mobile" => "landing_page/mobile.jpeg",
          "mobile_2x" => "landing_page/mobile_2x.jpeg",
          "tablet" => "landing_page/tablet.jpeg",
          "tablet_2x" => "landing_page/tablet_2x.jpeg",
        },
      } }
  end

  it_behaves_like "it is a landing-page block"

  describe "#image" do
    it "returns the properties of the image" do
      expect(image.image.alt).to eq "some alt text"
      expect(image.image.sources.desktop).to eq "landing_page/desktop.jpeg"
      expect(image.image.sources.desktop_2x).to eq "landing_page/desktop_2x.jpeg"
      expect(image.image.sources.mobile).to eq "landing_page/mobile.jpeg"
      expect(image.image.sources.mobile_2x).to eq "landing_page/mobile_2x.jpeg"
      expect(image.image.sources.tablet).to eq "landing_page/tablet.jpeg"
      expect(image.image.sources.tablet_2x).to eq "landing_page/tablet_2x.jpeg"
    end
  end
end
