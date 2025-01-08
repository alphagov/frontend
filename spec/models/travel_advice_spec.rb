RSpec.describe TravelAdvice do
  before do
    @content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "full-country")
  end

  it_behaves_like "it has parts", "travel_advice", "full-country"

  describe "#alert_status" do
    it "adds allowed statuses" do
      @content_store_response["details"]["alert_status"] = [described_class::ALERT_STATUSES.first]

      alert_statuses = described_class.new(@content_store_response).alert_status
      expect(alert_statuses).to eq([described_class::ALERT_STATUSES.first])
    end

    it "removes unexpected statuses" do
      @content_store_response["details"]["alert_status"] = %w[unexpected-status]

      alert_statuses = described_class.new(@content_store_response).alert_status
      expect(alert_statuses).to be_empty
    end

    it "returns nothing if there are no alerts" do
      alert_statuses = described_class.new(@content_store_response).alert_status
      expect(alert_statuses).to be_empty
    end
  end
end
