RSpec.shared_examples "it has updates" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name: example_name) }

  context "when first_public_at or first_published_at does not match public_updated_at" do
    it "knows its updated" do
      expect(described_class.new(content_store_response).updated).to eq(content_store_response["public_updated_at"])
    end
  end
end

RSpec.shared_examples "it has no updates" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name: example_name) }

  context "when first_public_at or first_published_at does match public_updated_at" do
    it "returns nil for updated" do
      expect(described_class.new(content_store_response).updated).to be_nil
    end

    it "returns an empty array for history" do
      expect(described_class.new(content_store_response).history).to eq([])
    end
  end
end
