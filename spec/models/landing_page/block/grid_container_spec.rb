RSpec.describe LandingPage::Block::GridContainer do
  let(:blocks_hash) do
    {
      "type" => "grid_container",
      "blocks" => [
        {
          "type" => "govspeak",
          "content" => "<p>Some content!</p>",
        },
        {
          "type" => "govspeak",
          "content" => "<p>Some more content!</p>",
        },
        {
          "type" => "govspeak",
          "content" => "<p>Even more content!</p>",
        },
      ],
    }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  it "has children blocks" do
    expect(subject.children.size).to eq(3)
  end
end
