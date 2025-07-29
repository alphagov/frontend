RSpec.describe StatisticalDataSet do
  subject(:document_collection) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set") }

  it_behaves_like "it has historical government information", "statistical_data_set", "statistical_data_set_political"
  it_behaves_like "it has updates", "statistical_data_set", "statistical_data_set_with_block_attachments"
  it_behaves_like "it has no updates", "statistical_data_set", "statistical_data_set"
  it_behaves_like "it can be withdrawn", "statistical_data_set", "statistical_data_set_withdrawn"

  describe "#headers" do
    context "when there are no headers in the content_item" do
      let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set_with_block_attachments") }

      it "returns an empty array" do
        expect(document_collection.headers).to eq([])
      end
    end

    context "when there are headers in the content item" do
      let(:content_store_response) { GovukSchemas::Example.find("statistical_data_set", example_name: "statistical_data_set") }

      it "returns the content item details/headers element" do
        expect(document_collection.headers).not_to be_empty
        expect(document_collection.headers).to eq(content_store_response["details"]["headers"])
      end
    end
  end
end
