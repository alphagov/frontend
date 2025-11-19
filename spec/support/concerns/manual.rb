RSpec.shared_examples "it can have section groups" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has section groups" do
    expect(described_class.new(content_item).section_groups).to eq(content_item.dig("details", "child_section_groups"))
  end
end

RSpec.shared_examples "it can be a manual" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has manual" do
    expect(described_class.new(content_item).manual?).to be true
  end
end

RSpec.shared_examples "it can be a manual section" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has manual section" do
    expect(described_class.new(content_item).manual?).to be true
  end
end
