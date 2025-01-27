RSpec.shared_examples "it can have worldwide organisations" do |schema|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name: schema) }

  it "knows it has worldwide organisations" do
    expect(described_class.new(content_store_response).worldwide_organisations.count).to eq(content_store_response["links"]["worldwide_organisations"].count)
  end
end
