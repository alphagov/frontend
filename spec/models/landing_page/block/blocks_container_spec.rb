RSpec.describe LandingPage::Block::BlocksContainer do
  let(:blocks_hash) do
    {
      "type" => "blocks_container",
      "blocks" => [
        {
          "type" => "govspeak",
          "content" => "<p>Some content!</p>",
        },
        {
          "type" => "heading",
          "content" => "Porem ipsum dolor",
        },
        {
          "type" => "govspeak",
          "content" => "<p>Some more content!</p>",
        },
      ],
    }
  end

  it "has children blocks" do
    expect(described_class.new(blocks_hash).children.size).to eq(3)
  end
end
