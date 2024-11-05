RSpec.describe LandingPage::Block::Featured do
  let(:blocks_hash) do
    { "type" => "featured",
      "image" => {
        "alt" => "some alt text",
        "sources" => {
          "hero_desktop_1x" => "landing_page/desktop.png",
          "hero_desktop_2x" => "landing_page/desktop_2x.png",
          "hero_tablet_1x" => "landing_page/tablet.png",
          "hero_tablet_2x" => "landing_page/tablet_2x.png",
          "hero_mobile_1x" => "landing_page/mobile.png",
          "hero_mobile_2x" => "landing_page/mobile_2x.png",
        },
      },
      "featured_content" => {
        "blocks" => [
          { "type" => "govspeak", "content" => "<p>Some content!</p>" },
          { "type" => "govspeak", "content" => "<p>More content!</p>" },
        ],
      } }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  describe "#image" do
    it "returns the properties of the image" do
      expect(subject.image.alt).to eq "some alt text"
    end

    it "allows access by source version" do
      expect(subject.image.sources.hero_desktop_1x).to eq "landing_page/desktop.png"
      expect(subject.image.sources.hero_desktop_2x).to eq "landing_page/desktop_2x.png"
      expect(subject.image.sources.hero_tablet_1x).to eq "landing_page/tablet.png"
      expect(subject.image.sources.hero_tablet_2x).to eq "landing_page/tablet_2x.png"
      expect(subject.image.sources.hero_mobile_1x).to eq "landing_page/mobile.png"
      expect(subject.image.sources.hero_mobile_2x).to eq "landing_page/mobile_2x.png"
    end

    it "returns nil if the requested version doesn't exist" do
      expect(subject.image.sources.hero_desktop_5x).to be_nil
    end
  end

  describe "#featured_content" do
    it "returns an array of instantiated blocks" do
      expect(subject.featured_content.size).to eq 2
      expect(subject.featured_content.first.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
      expect(subject.featured_content.second.data).to eq("type" => "govspeak", "content" => "<p>More content!</p>")
    end
  end

  describe "#full_width?" do
    it "is false" do
      expect(subject.full_width?).to eq(false)
    end
  end
end
