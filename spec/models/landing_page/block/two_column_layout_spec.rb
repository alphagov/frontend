RSpec.describe LandingPage::Block::TwoColumnLayout do
  subject(:two_column_layout) { described_class.new(blocks_hash, build(:landing_page)) }

  let(:blocks_hash) do
    { "type" => "two_column_layout",
      "theme" => "two_thirds_one_third",
      "blocks" => [
        { "type" => "govspeak", "content" => "<p>Left content!</p>" },
        { "type" => "govspeak", "content" => "<p>Right content!</p>" },
      ] }
  end

  it_behaves_like "it is a landing-page block"

  describe "#left_column_class" do
    it "returns two thirds when the theme is two_thirds_one_third" do
      expect(two_column_layout.left_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end

    it "returns one third when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(two_column_layout.left_column_class).to eq "govuk-grid-column-one-third"
    end

    it "returns offset column when the theme is two_thirds_right" do
      blocks_hash["theme"] = "two_thirds_right"
      expect(two_column_layout.left_column_class).to eq "govuk-grid-column-one-third grid-column-one-third-offset"
      expect(two_column_layout.left).to be_nil
    end
  end

  describe "#right_column_class" do
    it "returns two thirds when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(two_column_layout.right_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end

    it "returns one third when the theme is two_thirds_one_third" do
      blocks_hash["theme"] = "two_thirds_one_third"
      expect(two_column_layout.right_column_class).to eq "govuk-grid-column-one-third"
    end

    it "returns two thirds when the theme is two_thirds_right" do
      blocks_hash["theme"] = "two_thirds_right"
      expect(two_column_layout.right_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end
  end
end
