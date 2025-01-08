RSpec.describe LandingPage::Block::Featured do
  subject(:featured) { described_class.new(blocks_hash, build(:landing_page)) }

  let(:blocks_hash) do
    { "type" => "featured",
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
      },
      "featured_content" => {
        "blocks" => [
          { "type" => "govspeak", "content" => "<p>Some content!</p>" },
          { "type" => "govspeak", "content" => "<p>More content!</p>" },
        ],
      } }
  end

  it_behaves_like "it is a landing-page block"

  describe "#image" do
    it "returns the properties of the image" do
      expect(featured.image.alt).to eq "some alt text"
      expect(featured.image.sources.desktop).to eq "landing_page/desktop.jpeg"
      expect(featured.image.sources.desktop_2x).to eq "landing_page/desktop_2x.jpeg"
      expect(featured.image.sources.mobile).to eq "landing_page/mobile.jpeg"
      expect(featured.image.sources.mobile_2x).to eq "landing_page/mobile_2x.jpeg"
      expect(featured.image.sources.tablet).to eq "landing_page/tablet.jpeg"
      expect(featured.image.sources.tablet_2x).to eq "landing_page/tablet_2x.jpeg"
    end
  end

  describe "#featured_content" do
    it "returns an array of instantiated blocks" do
      expect(featured.featured_content.size).to eq 2
      expect(featured.featured_content.first.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
      expect(featured.featured_content.second.data).to eq("type" => "govspeak", "content" => "<p>More content!</p>")
    end
  end

  describe "#full_width?" do
    it "is false" do
      expect(featured.full_width?).to be(false)
    end
  end
end
