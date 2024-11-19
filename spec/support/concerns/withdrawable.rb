RSpec.shared_examples "it can be withdrawn" do |document_type, example_name|
  before do
    @content_store_response = GovukSchemas::Example.find(document_type, example_name:)
    @content_store_response["withdrawn_notice"] = {
      "explanation" => "<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>",
      "withdrawn_at" => "2024-07-16T12:36:44Z",
    }
  end

  it "knows it's withdrawn" do
    expect(described_class.new(@content_store_response).withdrawn?).to be true
  end

  it "knows when its withdrawn_at" do
    expect(described_class.new(@content_store_response).withdrawn_at).to eq("2024-07-16T12:36:44Z")
  end

  it "knows its withdrawn_explanation" do
    expect(described_class.new(@content_store_response).withdrawn_explanation).to eq("<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>")
  end
end
