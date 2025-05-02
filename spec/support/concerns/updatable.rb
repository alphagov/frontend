RSpec.shared_examples "it has updates" do |document_type, example_name, data_source: :content_store|
  let(:content_item) { fetch_content_item(document_type, example_name, data_source:) }

  context "when first_public_at or first_published_at does not match public_updated_at" do
    it "knows its updated" do
      expect(described_class.new(content_item).updated).to eq(content_item["public_updated_at"])
    end

    it "knows its history" do
      change_history = content_item["details"]["change_history"].map do |change|
        {
          note: change["note"],
          timestamp: change["public_timestamp"],
        }
      end
      sorted_change_history = change_history.sort_by { |item| Time.zone.parse(item[:timestamp]) }.reverse

      expect(described_class.new(content_item).history).to eq(sorted_change_history)
    end
  end
end

RSpec.shared_examples "it has no updates" do |document_type, example_name, data_source: :content_store|
  let(:content_item) { fetch_content_item(document_type, example_name, data_source:) }

  context "when first_public_at or first_published_at does match public_updated_at" do
    it "returns nil for updated" do
      expect(described_class.new(content_item).updated).to be_nil
    end

    it "returns an empty array for history" do
      expect(described_class.new(content_item).history).to eq([])
    end
  end

  context "when public_updated_at value is empty" do
    before do
      content_item["public_updated_at"] = nil
    end

    it "returns nil for updated" do
      expect(described_class.new(content_item).updated).to be_nil
    end
  end
end
