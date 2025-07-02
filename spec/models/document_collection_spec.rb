RSpec.describe DocumentCollection do
  subject(:content_item) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("document_collection", example_name: "document_collection") }

  it_behaves_like "it has updates", "document_collection", "document_collection_with_history"
  it_behaves_like "it has no updates", "document_collection", "document_collection"
  it_behaves_like "it has historical government information", "document_collection", "document_collection_political"
  it_behaves_like "it can be withdrawn", "document_collection", "document_collection_withdrawn"

  describe "#collection_groups" do
    it "returns an array of collection_group data mapped to data objects" do
      expect(content_item.collection_groups.count).to eq(6)
      expect(content_item.collection_groups.first).to be_instance_of(DocumentCollection::CollectionGroup)
    end
  end

  describe "#headers" do
    it "returns details/headers from the content store response" do
      expect(content_item.headers).to eq([])
    end
  end

  describe "taxonomy_topic_email_override_base_path" do
    it "returns nil" do
      expect(content_item.taxonomy_topic_email_override_base_path).to be_nil
    end

    context "when the taxonomy_topic_email_override_base_path is set in the content item" do
      let(:content_store_response) do
        GovukSchemas::Example.find("document_collection", example_name: "document_collection").tap do |item|
          item["links"]["taxonomy_topic_email_override"] = [{
            "base_path" => "/money/paying-hmrc",
          }]
        end
      end

      it "returns the path" do
        expect(content_item.taxonomy_topic_email_override_base_path).to eq("/money/paying-hmrc")
      end
    end
  end
end
