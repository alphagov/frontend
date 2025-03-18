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

  describe "#formatted_history" do
    it "returns the history with correctly formatted display_times" do
      history = [
        {
          note: "Information updated to include live link to Green Paper",
          timestamp: "2024-10-14T12:07:31.000+01:00",
        },
        {
          note: "First published.",
          timestamp: "2024-10-13T00:00:00.000+01:00",
        },
      ]

      expect(formatted_history(history).first[:display_time]).to eq("14 October 2024")
      expect(formatted_history(history).second[:display_time]).to eq("13 October 2024")
    end
  end
end
