RSpec.describe LandingPage::Block::Base do
  describe "#full_width?" do
    it "is false by default" do
      expect(described_class.new({}, build(:landing_page)).full_width?).to eq(false)
    end
  end

  describe "#full_background?" do
    let(:blocks_hash) do
      { "type" => "heading",
        "content" => "Rorem ipsum dolor sit" }
    end

    let(:subject) { described_class.new(blocks_hash, build(:landing_page)) }

    it "is false when full_background is not set" do
      expect(subject.full_background?).to be false
    end

    it "is true when full_background is set to true" do
      blocks_hash["full_background"] = true

      expect(subject.full_background?).to be true
    end
  end
end
