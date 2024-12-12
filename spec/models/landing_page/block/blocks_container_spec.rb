RSpec.describe LandingPage::Block::BlocksContainer do
  subject(:blocks_container) { described_class.new(blocks_hash, build(:landing_page)) }

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

  it_behaves_like "it is a landing-page block"

  it "has children blocks" do
    expect(blocks_container.children.size).to eq(3)
  end
end
