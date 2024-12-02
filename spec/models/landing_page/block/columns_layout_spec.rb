RSpec.describe LandingPage::Block::ColumnsLayout do
  it_behaves_like "it is a landing-page block"

  let(:blocks_hash) do
    {
      "type" => "columns_layout",
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

  it "has column blocks" do
    expect(subject.blocks.size).to eq(3)
  end
end
