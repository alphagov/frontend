RSpec.shared_examples "it can be withdrawn" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it is withdrawn" do
    expect(described_class.new(content_store_response).withdrawn?).to be true
  end

  it "knows when it has been withdrawn_at" do
    expect(described_class.new(content_store_response).withdrawn_at).to eq(content_store_response["withdrawn_notice"]["withdrawn_at"])
  end

  it "knows it has a withdrawn_explanation" do
    expect(described_class.new(content_store_response).withdrawn_explanation).to eq(content_store_response["withdrawn_notice"]["explanation"])
  end
end
