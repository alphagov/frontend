RSpec.describe DateHelper do
  include described_class

  let(:timestamp) { "2024-10-03 19:30:22 +0100" }

  describe "#display_date" do
    it "returns a formatted date" do
      expect(display_date(timestamp)).to eq("3 October 2024")
    end

    it "returns nil if passed nil" do
      expect(display_date(nil)).to be_nil
    end
  end
end
