RSpec.describe Block::Featured do
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

  describe "#image" do
    it "returns the properties of the image" do
      result = described_class.new(blocks_hash).image
      expect(result.alt).to eq "some alt text"
      expect(result.sources.desktop).to eq "landing_page/desktop.jpeg"
      expect(result.sources.desktop_2x).to eq "landing_page/desktop_2x.jpeg"
      expect(result.sources.mobile).to eq "landing_page/mobile.jpeg"
      expect(result.sources.mobile_2x).to eq "landing_page/mobile_2x.jpeg"
      expect(result.sources.tablet).to eq "landing_page/tablet.jpeg"
      expect(result.sources.tablet_2x).to eq "landing_page/tablet_2x.jpeg"
    end
  end

  describe "#featured_content" do
    it "returns an array of instantiated blocks" do
      result = described_class.new(blocks_hash).featured_content
      expect(result.size).to eq 2
      expect(result.first.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
      expect(result.second.data).to eq("type" => "govspeak", "content" => "<p>More content!</p>")
    end
  end

  describe "#full_width?" do
    it "is false" do
      expect(described_class.new(blocks_hash).full_width?).to eq(false)
    end
  end
end
