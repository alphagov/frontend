RSpec.shared_examples "it can have national applicability" do |document_type, example_name|
  content_store_response = GovukSchemas::Example.find(document_type, example_name:)

  it "knows it has national applicability" do
    expect(described_class.new(content_store_response).national_applicability.present?).to be true
  end

  it "knows the national applicability details" do
    expected_national_applicability = content_store_response["details"]["national_applicability"]&.deep_symbolize_keys

    expect(described_class.new(content_store_response).national_applicability).to eq(expected_national_applicability)
  end
end
