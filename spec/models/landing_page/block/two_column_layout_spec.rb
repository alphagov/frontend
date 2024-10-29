RSpec.describe LandingPage::Block::TwoColumnLayout do
  let(:blocks_hash) do
    { "type" => "two_column_layout",
      "theme" => "two_thirds_one_third",
      "blocks" => [
        { "type" => "govspeak", "content" => "<p>Left content!</p>" },
        { "type" => "govspeak", "content" => "<p>Right content!</p>" },
      ] }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  describe "#left_column_size" do
    it "returns 2 when the theme is two_thirds_one_third" do
      expect(subject.left_column_size).to eq 2
    end

    it "returns 1 when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(subject.left_column_size).to eq 1
    end
  end

  describe "#right_column_size" do
    it "returns 2 when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(subject.right_column_size).to eq 2
    end

    it "returns 1 when the theme is two_thirds_one_third" do
      expect(subject.right_column_size).to eq 1
    end
  end

  describe "#total_columns" do
    it "returns the total number of columns in the theme" do
      expect(subject.total_columns).to eq 3
    end
  end
end
