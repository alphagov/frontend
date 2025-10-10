RSpec.shared_examples "it can have phases with a running time period" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "can have an opening date and time" do
    expect(described_class.new(content_store_response).opening_date_time).to eq(content_store_response["details"]["opening_date"])
  end

  it "can have a closing date and time" do
    expect(described_class.new(content_store_response).closing_date_time).to eq(content_store_response["details"]["closing_date"])
  end
end
