RSpec.describe LandingPage::Block::TwoColumnLayout do
  it_behaves_like "it is a landing-page block"

  let(:blocks_hash) do
    { "type" => "two_column_layout",
      "theme" => "two_thirds_one_third",
      "blocks" => [
        { "type" => "govspeak", "content" => "<p>Left content!</p>" },
        { "type" => "govspeak", "content" => "<p>Right content!</p>" },
      ] }
  end
  let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

  describe "#left_column_class" do
    it "returns two thirds when the theme is two_thirds_one_third" do
      expect(subject.left_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end

    it "returns one third when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(subject.left_column_class).to eq "govuk-grid-column-one-third"
    end

    it "returns offset column when the theme is two_thirds_right" do
      blocks_hash["theme"] = "two_thirds_right"
      expect(subject.left_column_class).to eq "govuk-grid-column-one-third grid-column-one-third-offset"
      expect(subject.left).to eq nil
    end
  end

  describe "#right_column_class" do
    it "returns two thirds when the theme is one_third_two_thirds" do
      blocks_hash["theme"] = "one_third_two_thirds"
      expect(subject.right_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end

    it "returns one third when the theme is two_thirds_one_third" do
      blocks_hash["theme"] = "two_thirds_one_third"
      expect(subject.right_column_class).to eq "govuk-grid-column-one-third"
    end

    it "returns two thirds when the theme is two_thirds_right" do
      blocks_hash["theme"] = "two_thirds_right"
      expect(subject.right_column_class).to eq "govuk-grid-column-two-thirds-from-desktop"
    end
  end
end
