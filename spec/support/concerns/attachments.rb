RSpec.shared_examples "it can have attachments" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:expected_attachments) { content_store_response["details"]["attachments"] }

  it "knows it has attachments" do
    expect(described_class.new(content_store_response).attachments).to eq(expected_attachments)
  end

  it "knows it has featured attachments" do
    featured_attachments_list = content_store_response["details"]["featured_attachments"]
    expected_featured_attachments = expected_attachments.select { |doc| (featured_attachments_list || []).include? doc["id"] }

    expect(described_class.new(content_store_response).attachments_from(featured_attachments_list)).to eq(expected_featured_attachments)
  end
end
