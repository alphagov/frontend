RSpec.shared_examples "it can be withdrawn" do |document_type, example_name|
  before do
    @example_doc = GovukSchemas::Example.find(document_type, example_name:)
    @example_doc["withdrawn"] = {
      "explanation" => "<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>",
      "withdrawn_at" => "2024-07-16T12:36:44Z",
    }
  end

  it "knows it's withdrawn" do
    expect(described_class.new(@example_doc).withdrawn?).to be true
  end

  it "knows it's withdrawal_notice" do
    expect(described_class.new(@example_doc).withdrawal_notice).to eq(
      "explanation" => "<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>",
      "withdrawn_at" => "2015-01-28T13:05:30Z",
    )
  end

  it "knows when its withdrawn_at" do
    expect(described_class.new(@example_doc).withdrawn_at).to eq("2015-01-28T13:05:30Z")
  end

  it "knows it's withdrawn_explaination" do
    expect(described_class.new(@example_doc).withdrawn_explaination).to eq("<div class=\"govspeak\"><p>This information has been archived as it is now out of date. For current information please go to <a rel=\"external\" href=\"http://www.hse.gov.uk/reach/\">http://www.hse.gov.uk/reach/</a></p></div>")
  end
end
