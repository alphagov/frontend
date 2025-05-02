RSpec.shared_examples "it can have people" do |schema, data_source: :content_store|
  let(:api_response) { fetch_content_item(schema, schema, data_source:) }

  it "knows it has people" do
    expect(described_class.new(api_response).people.count).to eq(api_response["links"]["people"].count)
  end
end
