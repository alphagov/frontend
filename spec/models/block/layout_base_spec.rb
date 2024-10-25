RSpec.describe Block::LayoutBase do
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

    let(:landing_page) { nil }

    it "builds all of the blocks" do
      expect(described_class.new(blocks_hash, landing_page).blocks.count).to eq 3
    end

    it "builds blocks of the correct type" do
      expect(described_class.new(blocks_hash, landing_page).blocks.first.type).to eq("big_number")
    end
  end
end
