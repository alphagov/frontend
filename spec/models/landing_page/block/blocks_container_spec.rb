RSpec.describe LandingPage::Block::BlocksContainer do
  it_behaves_like "it is a landing-page block"

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
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  it "has children blocks" do
    expect(subject.children.size).to eq(3)
  end
end
