RSpec.shared_examples "it can have single page notifications" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows it has single page notifications" do
    expect(described_class.new(@content_store_response).has_single_page_notifications?).to eq true
  end
end
