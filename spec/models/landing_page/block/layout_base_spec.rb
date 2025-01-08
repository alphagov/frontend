RSpec.describe LandingPage::Block::LayoutBase do
  describe "#blocks" do
    subject(:layout_base) { described_class.new(blocks_hash, build(:landing_page)) }

    let(:blocks_hash) do
      {
        "blocks" => [
          { "type" => "govspeak", "content" => "test1" },
          { "type" => "govspeak", "content" => "test2" },
          { "type" => "govspeak", "content" => "test3" },
        ],
      }
    end

    it "builds all of the blocks" do
      expect(layout_base.blocks.count).to eq 3
    end

    it "builds blocks of the correct type" do
      expect(layout_base.blocks.first.type).to eq("govspeak")
    end
  end
end
