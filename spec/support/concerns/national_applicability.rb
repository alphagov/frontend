RSpec.shared_examples "it can have national applicability" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
  end

  it "knows its national applicability information" do
    expected_national_applicability = @content_store_response["details"]["national_applicability"]&.deep_symbolize_keys
    expect(described_class.new(@content_store_response).national_applicability).to eq(expected_national_applicability)
  end
end
