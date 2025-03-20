RSpec.shared_examples "it can have worldwide organisations" do |schema, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name:) }

  it "knows it has worldwide organisations" do
    expect(described_class.new(content_store_response).worldwide_organisations.count).to eq(content_store_response["links"]["worldwide_organisations"].count)
  end
end
