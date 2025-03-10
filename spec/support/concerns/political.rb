RSpec.shared_examples "it has historical government information" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }

  it "knows it is part of historical government if it is not the current government" do
    content_store_response["links"]["government"][0]["details"]["current"] = false
    expect(described_class.new(content_store_response).historically_political?).to be(true)
  end

  it "knows it is not part of historical government if it is the current government" do
    content_store_response["links"]["government"][0]["details"]["current"] = true
    expect(described_class.new(content_store_response).historically_political?).to be(false)
  end

  it "knows it would be part of historical government if there is no government" do
    content_store_response["links"]["government"][0]["details"]["current"] = nil
    expect(described_class.new(content_store_response).historically_political?).to be(false)
  end

  it "knows it is not political" do
    content_store_response["details"]["political"] = false
    expect(described_class.new(content_store_response).historically_political?).to be(false)
  end

  it "knows it is publishing government" do
    expected_publishing_government = content_store_response.dig("links", "government", 0, "title")
    expect(described_class.new(content_store_response).publishing_government).to eq(expected_publishing_government)
  end
end
