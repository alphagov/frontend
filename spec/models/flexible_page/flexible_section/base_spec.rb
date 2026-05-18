RSpec.describe FlexiblePage::FlexibleSection::Base do
  subject(:base) { described_class.new({}) }

  describe "#before_content?" do
    it "returns false - default is in normal content flow" do
      expect(base.before_content?).to be false
    end
  end

  describe "#type" do
    it "returns the terminal class name in snakecase suitable for a partial lookup" do
      expect(base.type).to eq("base")
    end
  end
end
