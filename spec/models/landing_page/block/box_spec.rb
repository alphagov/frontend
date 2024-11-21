RSpec.describe LandingPage::Block::Box do
  let(:blocks_hash) do
    { "type" => "box",
      "href" => "/landing-page/something",
      "content" => "This is a link",
      "box_content" => {
        "blocks" => [
          { "type" => "govspeak", "content" => "<h2>Title</h2>" },
          { "type" => "govspeak", "content" => "<p>Some content!</p>" },
        ],
      } }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  it "includes a link" do
    expect(subject.href).to eq "/landing-page/something"
    expect(subject.content).to eq "This is a link"
  end

  describe "#box_content" do
    it "returns an array of instantiated blocks" do
      expect(subject.box_content.size).to eq 2
      expect(subject.box_content.first.data).to eq("type" => "govspeak", "content" => "<h2>Title</h2>")
      expect(subject.box_content.second.data).to eq("type" => "govspeak", "content" => "<p>Some content!</p>")
    end
  end
end
