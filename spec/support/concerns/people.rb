RSpec.shared_examples "it can have people" do |document_type, example_name, data_source: :content_store|
  let(:content_item) { fetch_content_item(document_type, example_name, data_source:) }

  it "knows it has people" do
    expect(described_class.new(content_item).people.count).to eq(content_item["links"]["people"].count)
  end
end
