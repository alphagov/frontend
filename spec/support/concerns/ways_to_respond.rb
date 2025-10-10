RSpec.shared_examples "it can have ways to respond" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "has the open_<schema_name> document type" do
    expect(content_store_response["document_type"]).to eq("open_#{content_store_response['schema_name']}")
  end

  describe "#held_on_another_website_url" do
    it "returns url if it is held on another website" do
      expected_url = content_store_response["details"]["held_on_another_website_url"]

      expect(described_class.new(content_store_response).held_on_another_website_url).to be_present
      expect(described_class.new(content_store_response).held_on_another_website_url).to eq(expected_url)
    end

    it "does not return url if it is not held on another website" do
      content_store_response["details"].delete("held_on_another_website_url")

      expect(described_class.new(content_store_response).held_on_another_website_url).to be_nil
    end
  end
end
