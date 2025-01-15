RSpec.shared_examples "it has updates" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name: example_name) }

  context "when first_public_at does not match public_updated_at then there are updates" do
    before do
      content_store_response["details"]["first_public_at"] = "2024-05-23T00:00:00.000+01:00"
    end

    it "knows its updated" do
      expect(described_class.new(content_store_response).updated).to eq(content_store_response["public_updated_at"])
    end

    it "knows its history" do
      change_history = content_store_response["details"]["change_history"].map do |change|
        {
          display_time: change["public_timestamp"],
          note: change["note"],
          timestamp: change["public_timestamp"],
        }
      end
      expect(described_class.new(content_store_response).history).to eq(change_history)
    end
  end

  context "when first_public_at matches public_updated_at then there are no updates" do
    it "returns nil for updated" do
      expect(described_class.new(content_store_response).updated).to be_nil
    end

    it "returns an empty array for history" do
      expect(described_class.new(content_store_response).history).to eq([])
    end
  end
end
