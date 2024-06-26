RSpec.describe CurrencyHelper, type: :view do
  include CurrencyHelper

  before { @sample_number = "12000" }

  describe "#format_amount" do
    it "returns a formatted number" do
      expect(format_amount(@sample_number)).to eq("12,000 euros")
    end

    it "returns nil if passed nil" do
      expect(format_amount(nil)).to be_nil
    end
  end
end
