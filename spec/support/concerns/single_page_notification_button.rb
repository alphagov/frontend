RSpec.shared_examples "it can have single page notifications" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it has single page notification for English pages and page is not in exemption list" do
    expect(described_class.new(content_store_response).display_single_page_notification_button?).to be(true)
  end

  it "knows it does not have single page notification when page is on exemption list" do
    content_store_response["content_id"] = "c5c8d3cd-0dc2-4ca3-8672-8ca0a6e92165"
    expect(described_class.new(content_store_response).display_single_page_notification_button?).to be(false)
  end

  it "knows it does not have single page notification for foreign language pages" do
    content_store_response["locale"] = "cy"
    expect(described_class.new(content_store_response).display_single_page_notification_button?).to be(false)
  end
end
