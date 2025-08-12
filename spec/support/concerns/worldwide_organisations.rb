RSpec.shared_examples "it can have worldwide organisations" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has worldwide organisations" do
    expect(described_class.new(content_item).worldwide_organisations.count).to eq(content_item["links"]["worldwide_organisations"].count)
  end
end
