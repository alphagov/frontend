RSpec.describe LandingPage::Block::Hero do
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }
  let(:blocks_hash) do
    { "type" => "hero",
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
      "hero_content" => {
        "blocks" => [
          { "type" => "govspeak", "content" => "<p>Some content!</p>" },
          { "type" => "govspeak", "content" => "<p>More content!</p>" },
        ],
      } }
  end

  it_behaves_like "it is a landing-page block"

  describe "#image" do
    it "returns the properties of the image" do
      expect(subject.image.alt).to eq "some alt text"
      expect(subject.image.sources.desktop).to eq "landing_page/desktop.jpeg"
      expect(subject.image.sources.desktop_2x).to eq "landing_page/desktop_2x.jpeg"
      expect(subject.image.sources.mobile).to eq "landing_page/mobile.jpeg"
      expect(subject.image.sources.mobile_2x).to eq "landing_page/mobile_2x.jpeg"
      expect(subject.image.sources.tablet).to eq "landing_page/tablet.jpeg"
      expect(subject.image.sources.tablet_2x).to eq "landing_page/tablet_2x.jpeg"
    end
  end

  describe "#hero_content" do
    it "returns an array of instantiated blocks" do
      expect(subject.hero_content.size).to eq 2
      expect(subject.hero_content.first.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
      expect(subject.hero_content.second.data).to eq("type" => "govspeak", "content" => "<p>More content!</p>")
    end

    it "returns nil if hero_content isn't provided" do
      blocks_hash = {
        "type" => "hero",
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
      }

      hero_block = described_class.new(blocks_hash, build(:landing_page))

      expect(hero_block.hero_content).to be_nil
    end
  end

  describe "#theme" do
    it "defaults to default" do
      expect(subject.theme).to eq("default")
    end

    it "returns the theme from config" do
      blocks_hash["theme"] = "middle_left"
      expect(subject.theme).to eq("middle_left")
    end
  end

  describe "#theme_colour" do
    it "defaults to nil" do
      expect(subject.theme_colour).to be_nil
    end

    it "returns the theme_colour from config" do
      blocks_hash["theme_colour"] = 2
      expect(subject.theme_colour).to eq(2)
    end
  end

  describe "#full_width?" do
    it "is true" do
      expect(subject.full_width?).to be(true)
    end
  end
end
