RSpec.shared_examples "it can have people" do |schema|
  let(:content_store_response) { GovukSchemas::Example.find(schema, example_name: schema) }

  it "knows it has people" do
    expect(described_class.new(content_store_response).people.count).to eq(content_store_response["links"]["people"].count)
  end
end
