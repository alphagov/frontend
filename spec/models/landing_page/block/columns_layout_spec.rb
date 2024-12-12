RSpec.describe LandingPage::Block::ColumnsLayout do
  subject(:columns_layout) { described_class.new(blocks_hash, build(:landing_page)) }

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

  it_behaves_like "it is a landing-page block"

  it "has column blocks" do
    expect(columns_layout.blocks.size).to eq(3)
  end
end
