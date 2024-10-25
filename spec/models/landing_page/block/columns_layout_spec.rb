RSpec.describe LandingPage::Block::ColumnsLayout do
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

  it "has column blocks" do
    expect(described_class.new(blocks_hash).columns.size).to eq(3)
  end
end
