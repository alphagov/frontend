RSpec.describe LandingPage::Block::Card do
  let(:blocks_hash) do
    { "type" => "card",
      "href" => "/landing-page/something",
      "content" => "This is a link",
      "link_cover_block" => true,
      "image" => {
        "alt" => "some alt text",
        "source" => "landing_page/placeholder/chart.png",
      },
      "card_content" => {
        "blocks" => [
          { "type" => "govspeak", "content" => "<h2>Title</h2>" },
          { "type" => "govspeak", "content" => "<p>Some content!</p>" },
        ],
      } }
  end

  describe "#link" do
    it "includes a link" do
      result = described_class.new(blocks_hash)
      expect(result.href).to eq "/landing-page/something"
      expect(result.content).to eq "This is a link"
      expect(result.link_cover_block).to eq true
    end
  end

  describe "#image" do
    it "returns the properties of the image" do
      result = described_class.new(blocks_hash).image
      expect(result.alt).to eq "some alt text"
      expect(result.source).to eq "landing_page/placeholder/chart.png"
    end
  end

  describe "#card_content" do
    it "returns an array of instantiated blocks" do
      result = described_class.new(blocks_hash).card_content
      expect(result.size).to eq 2
      expect(result.first.data).to eq("type" => "govspeak", "content" => "<h2>Title</h2>")
      expect(result.second.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
    end
  end
end
