RSpec.shared_examples "it can have attachments" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows it has attachments" do
    expected_attachments = @content_store_response["details"]["attachments"]

    expect(described_class.new(@content_store_response).attachments).to eq(expected_attachments)
  end

  it "knows it has featured attachments" do
    expected_attachments = @content_store_response["details"]["attachments"]
    featured_attachments_list = @content_store_response["details"]["featured_attachments"]
    expected_featured_attachments = expected_attachments.select { |doc| (featured_attachments_list || []).include? doc["id"] }

    expect(described_class.new(@content_store_response).attachments_from(featured_attachments_list)).to eq(expected_featured_attachments)
  end
end
