RSpec.shared_examples "it can have worldwide organisations" do |schema, example_name, data_source: :content_store|
  let(:api_response) { fetch_content_item(schema, example_name, data_source:) }

  it "knows it has worldwide organisations" do
    expect(described_class.new(api_response).worldwide_organisations.count).to eq(api_response["links"]["worldwide_organisations"].count)
  end
end
