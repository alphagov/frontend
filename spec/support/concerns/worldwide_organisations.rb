RSpec.shared_examples "it can have worldwide organisations" do |document_type, example_name, data_source: :content_store|
  let(:content_item) { fetch_content_item(document_type, example_name, data_source:) }

  it "knows it has worldwide organisations" do
    expect(described_class.new(content_item).worldwide_organisations.count).to eq(content_item["links"]["worldwide_organisations"].count)
  end
end
