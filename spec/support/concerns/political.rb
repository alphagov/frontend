RSpec.shared_examples "it has historical government information" do |document_type, example_name, data_source: :content_store|
  let(:api_response) { fetch_content_item(document_type, example_name, data_source:) }

  it "knows it is part of historical government if it is not the current government" do
    api_response["links"]["government"][0]["details"]["current"] = false
    expect(described_class.new(api_response).historically_political?).to be(true)
  end

  it "knows it is not part of historical government if it is the current government" do
    api_response["links"]["government"][0]["details"]["current"] = true
    expect(described_class.new(api_response).historically_political?).to be(false)
  end

  it "knows it would be part of historical government if there is no government" do
    api_response["links"]["government"][0]["details"]["current"] = nil
    expect(described_class.new(api_response).historically_political?).to be(false)
  end

  it "knows it is not political" do
    api_response["details"]["political"] = false
    expect(described_class.new(api_response).historically_political?).to be(false)
  end

  it "knows it is publishing government" do
    expected_publishing_government = api_response.dig("links", "government", 0, "title")
    expect(described_class.new(api_response).publishing_government).to eq(expected_publishing_government)
  end
end
