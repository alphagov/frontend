RSpec.describe StatisticsAnnouncementPresenter do
  subject(:presenter) { described_class.new(content_item) }

  let(:content_item) { StatisticsAnnouncement.new(content_store_response) }
  let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "official_statistics") }

  describe "#important_metadata" do
    context "when announcement is cancelled" do
      let(:content_store_response) { GovukSchemas::Example.find("statistics_announcement", example_name: "cancelled_official_statistics") }

      it "returns cancellation date" do
        expected_metadata = {
          "Proposed release" => "20 January 2016 9:30am",
          "Cancellation date" => "17 January 2016 2:19pm",
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end

    context "when the announcement is upcoming" do
      it "returns the release date" do
        expected_metadata = {
          "Release date" => "20 January 2016 9:30am (confirmed)",
        }

        expect(presenter.important_metadata).to include(expected_metadata)
      end
    end
  end
end
