RSpec.shared_examples "it can be withdrawn" do |document_type, example_name, data_source: :content_store|
  let(:api_response) { fetch_content_item(document_type, example_name, data_source:) }

  it "knows it is withdrawn" do
    expect(described_class.new(api_response).withdrawn?).to be true
  end

  it "knows when it has been withdrawn_at" do
    expect(described_class.new(api_response).withdrawn_at).to eq(api_response["withdrawn_notice"]["withdrawn_at"])
  end

  it "knows it has a withdrawn_explanation" do
    expect(described_class.new(api_response).withdrawn_explanation).to eq(api_response["withdrawn_notice"]["explanation"])
  end
end
