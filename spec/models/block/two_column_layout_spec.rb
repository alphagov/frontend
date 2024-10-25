RSpec.describe Block::TwoColumnLayout do
  let(:blocks_hash) do
    { "type" => "two_column_layout",
      "theme" => "two_thirds_one_third",
      "blocks" => [
        { "type" => "govspeak", "content" => "<p>Left content!</p>" },
        { "type" => "govspeak", "content" => "<p>Right content!</p>" },
      ] }
  end

  let(:landing_page) { nil }

  describe "#left_column_size" do
    it "returns 2 when the theme is two_thirds_one_third" do
      expect(described_class.new(blocks_hash, landing_page).left_column_size).to eq 2
    end

    it "returns 1 when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(described_class.new(blocks_hash, landing_page).left_column_size).to eq 1
    end
  end

  describe "#right_column_size" do
    it "returns 2 when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(described_class.new(blocks_hash, landing_page).right_column_size).to eq 2
    end

    it "returns 1 when the theme is two_thirds_one_third" do
      expect(described_class.new(blocks_hash, landing_page).right_column_size).to eq 1
    end
  end

  describe "#total_columns" do
    it "returns the total number of columns in the theme" do
      expect(described_class.new(blocks_hash, landing_page).total_columns).to eq 3
    end
  end
end
