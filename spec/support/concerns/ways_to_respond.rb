RSpec.shared_examples "it can have ways to respond" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "has the open_<schema_name> document type" do
    expect(content_store_response["document_type"]).to eq("open_#{content_store_response['schema_name']}")
  end
end
