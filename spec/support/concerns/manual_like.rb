RSpec.shared_examples "it can have section groups" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has section groups" do
    expect(described_class.new(content_item).section_groups).to eq(content_item.dig("details", "child_section_groups"))
  end
end
