RSpec.shared_examples "it can have single page notifications" do |document_type, example_name|
  it "knows it has single page notifications" do
    content_store_response = GovukSchemas::Example.find(document_type, example_name:)

    expect(described_class.new(content_store_response).has_single_page_notifications?).to be(true)
  end
end
