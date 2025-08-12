RSpec.shared_examples "it can have people" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has people" do
    expect(described_class.new(content_item).people.count).to eq(content_item["links"]["people"].count)
  end
end
