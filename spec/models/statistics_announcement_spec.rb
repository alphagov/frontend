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
end
