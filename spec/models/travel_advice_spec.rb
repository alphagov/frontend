RSpec.describe TravelAdvice do
  let(:content_store_response) { GovukSchemas::Example.find("travel_advice", example_name: "full-country") }

  it_behaves_like "it has parts", "travel_advice", "full-country"
  it_behaves_like "it can be withdrawn", "travel_advice", "withdrawn-full-country"

  describe "#alert_status" do
    it "adds allowed statuses" do
      content_store_response["details"]["alert_status"] = [described_class::ALERT_STATUSES.first]

      alert_statuses = described_class.new(content_store_response).alert_status
      expect(alert_statuses).to eq([described_class::ALERT_STATUSES.first])
    end

    it "removes unexpected statuses" do
      content_store_response["details"]["alert_status"] = %w[unexpected-status]

      alert_statuses = described_class.new(content_store_response).alert_status
      expect(alert_statuses).to be_empty
    end

    it "returns nothing if there are no alerts" do
      alert_statuses = described_class.new(content_store_response).alert_status
      expect(alert_statuses).to be_empty
    end
  end

  describe "#map_download_file_size" do
    it "returns the file size when present" do
      content_store_response["details"]["document"] = {
        "url" => "https://example.com/map.pdf",
        "file_size" => 201_672,
      }

      travel_advice = described_class.new(content_store_response)
      expect(travel_advice.map_download_file_size).to eq(201_672)
    end
  end
end
