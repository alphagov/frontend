RSpec.shared_examples "it can be withdrawn" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows it's withdrawn" do
    expect(described_class.new(@content_store_response).withdrawn?).to be true
  end
end