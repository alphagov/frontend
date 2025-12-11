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

  describe "#release_date_changed?" do
    let(:statistics_announcement_date_changed) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "release_date_changed")) }

    it "returns true if the release date was changed" do
      expect(statistics_announcement_date_changed.release_date_changed?).to be true
    end

    it "returns false if the release date hasn't changed" do
      expect(official_statistics.release_date_changed?).to be false
    end
  end

  describe "#release_date_and_status when confirmed" do
    it "returns the release date and status" do
      expect(official_statistics.release_date_and_status).to eq("20 January 2016 9:30am (confirmed)")
    end
  end

  describe "#release_date_and_status when cancelled" do
    let(:cancelled_official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "cancelled_official_statistics")) }

    it "returns only the release date" do
      expect(cancelled_official_statistics.release_date_and_status).to eq("20 January 2016 9:30am")
    end
  end

  describe "#forthcoming_publication?" do
    let(:cancelled_official_statistics) { described_class.new(GovukSchemas::Example.find("statistics_announcement", example_name: "cancelled_official_statistics")) }

    it "returns true if an announcement is forthcoming" do
      expect(official_statistics.forthcoming_publication?).to be true
    end

    it "returns false if an announcement is cancelled" do
      expect(cancelled_official_statistics.forthcoming_publication?).to be false
    end
  end

  describe '#on_in_between_for_release_date' do
    it "returns 'on' if the date is an exact format" do
      expect(official_statistics.on_in_between_for_release_date("10 January 2017 9:30am")).to eq("on 10 January 2017 9:30am")
      expect(official_statistics.on_in_between_for_release_date("1 December 2010 11:30pm")).to eq("on 1 December 2010 11:30pm")
    end

    it "returns 'in' if the date is a one month format" do
      expect(official_statistics.on_in_between_for_release_date("January 2018")).to eq("in January 2018")
    end

    it "returns 'between' and replaces 'to' with 'and' if the date is a two month format" do
      expect(official_statistics.on_in_between_for_release_date("March to April 2018")).to eq("between March and April 2018")
    end

    it "returns the passed in string if it doesn't match any format" do
      expect(official_statistics.on_in_between_for_release_date("some or other unexpected date format")).to eq("some or other unexpected date format")
    end 
  end
end
