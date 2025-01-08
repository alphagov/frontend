RSpec.describe LandingPage::Block::Card do
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }
  let(:blocks_hash) do
    { "type" => "card",
      "href" => "/landing-page/something",
      "content" => "This is a link",
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

  it_behaves_like "it is a landing-page block"

  describe "#link" do
    it "includes a link" do
      expect(subject.href).to eq "/landing-page/something"
      expect(subject.content).to eq "This is a link"
    end
  end

  describe "#image" do
    it "returns the properties of the image" do
      expect(subject.image.alt).to eq "some alt text"
      expect(subject.image.source).to eq "landing_page/placeholder/chart.png"
    end
  end

  describe "#card_content" do
    it "returns an array of instantiated blocks" do
      expect(subject.card_content.size).to eq 2
      expect(subject.card_content.first.data).to eq("type" => "govspeak", "content" => "<h2>Title</h2>")
      expect(subject.card_content.second.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
    end
  end
end
