RSpec.shared_examples "it can have manual updates" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has change history" do
    expect(described_class.new(content_item).change_notes).to eq(content_item.dig("details", "change_notes"))
  end
end
