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
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  it "has column blocks" do
    expect(subject.columns.size).to eq(3)
  end
end
