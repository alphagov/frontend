RSpec.describe StatisticsAnnouncement do
  let(:official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics")) }

  describe "#release_date" do
    it "returns the release date" do
      expect(official_statistics.release_date).to eq("20 January 2016 9:30am")
    end
  end

  describe "#release_date_and_status when confirmed" do
    it "returns the release date and status" do
      expect(official_statistics.release_date_and_status).to eq("20 January 2016 9:30am (confirmed)")
    end
  end

  describe "#release_date_and_status when canceled" do
    let(:cancelled_official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "cancelled_official_statistics")) }
  
    it "returns the release date and status" do
      expect(cancelled_official_statistics.release_date_and_status).to eq("20 January 2016 9:30am")
    end
  end

  describe "#release_date_changed?" do
    let(:statistics_announcement_date_changed) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "release_date_changed")) }

    it "returns if the release date was changed" do
      expect(statistics_announcement_date_changed.release_date_changed?).to be true
      expect(official_statistics.release_date_changed?).to be false
    end
  end
end
