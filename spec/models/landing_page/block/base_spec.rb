RSpec.describe LandingPage::Block::Base do
  describe "#full_width?" do
    it "is false by default" do
      expect(described_class.new({}).full_width?).to eq(false)
    end
  end
end
