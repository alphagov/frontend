RSpec.describe StatisticsAnnouncement do
  describe "updatable" do
    let(:statistics_announcement) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "best-practice-statistics-announcement")) }

    it "knows its updated" do
      expect(statistics_announcement.updated).to eq(statistics_announcement.public_updated_at)
    end
  end
end
