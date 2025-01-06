RSpec.describe LandingPage::Block::LayoutBase do
  describe "#blocks" do
    let(:blocks_hash) do
      {
        "blocks" => [
          { "type" => "govspeak", "content" => "test1" },
          { "type" => "govspeak", "content" => "test2" },
          { "type" => "govspeak", "content" => "test3" },
        ],
      }
    end
    let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

    it "builds all of the blocks" do
      expect(subject.blocks.count).to eq 3
    end

    it "builds blocks of the correct type" do
      expect(subject.blocks.first.type).to eq("govspeak")
    end
  end
end
