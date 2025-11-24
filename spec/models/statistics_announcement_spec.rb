RSpec.describe StatisticsAnnouncement do
  let(:official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics")) }

  it_behaves_like "it has updates", "statistics_announcement", "official_statistics"

  describe "#release_date" do
    it "returns the release date" do
      expect(official_statistics.release_date).to eq("2016-09-05T14:00:00+01:00")
    end
  end
end
