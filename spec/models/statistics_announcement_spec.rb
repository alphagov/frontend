RSpec.describe StatisticsAnnouncement do
  let(:official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics")) }

  describe "updatable" do
    let(:statistics_announcement) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "best-practice-statistics-announcement")) }

    it "knows its updated" do
      expect(statistics_announcement.updated).to eq(statistics_announcement.public_updated_at)
    end
  end

  describe "#release_date" do
    it "returns the release date" do
      expect(official_statistics.release_date).to eq("20 January 2016 9:30am")
    end
  end
end
