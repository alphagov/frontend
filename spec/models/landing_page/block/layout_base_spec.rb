RSpec.describe LandingPage::Block::LayoutBase do
  describe "#blocks" do
    let(:blocks_hash) do
      {
        "blocks" => [
          { "type" => "big_number", "number" => "£75m", "label" => "amount of money that looks big" },
          { "type" => "big_number", "number" => "100%", "label" => "increase in the number of big_number components added to the columns at this point" },
          { "type" => "big_number", "number" => "£43", "label" => "Cost of a cup of coffee in Covent Garden" },
        ],
      }
    end

    it "builds all of the blocks" do
      expect(described_class.new(blocks_hash).blocks.count).to eq 3
    end

    it "builds blocks of the correct type" do
      expect(described_class.new(blocks_hash).blocks.first.type).to eq("big_number")
    end
  end
end
