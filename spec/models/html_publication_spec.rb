RSpec.describe HtmlPublication do
  subject(:html_publication) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "published") }

  it "returns a parent" do
    expect(html_publication.parent.content_id).to eq("8b19c238-54e3-4e27-b0d7-60f8e2a677c9")
  end

  it "returns organisations" do
    expect(html_publication.organisations.length).to eq(1)
    expect(html_publication.organisations[0].title).to eq("Environment Agency")
  end

  it "returns public timestamp" do
    expect(html_publication.public_timestamp).to eq("2016-01-17T14:19:42.460Z")
  end

  it "returns first published version" do
    expect(html_publication.first_published_version).to be(true)
  end

  context "when content is not historically political" do
    let(:content_store_response) do
      GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode").tap do |example|
        example["details"]["political"] = false
      end
    end

    it "political is false" do
      expect(html_publication.historically_political?).to be(false)
    end
  end

  context "when content is historically political" do
    let(:content_store_response) do
      GovukSchemas::Example.find(:html_publication, example_name: "published_with_history_mode").tap do |example|
        example["details"]["political"] = true
        example["links"]["government"][0]["details"]["current"] = false
      end
    end

    it "political is true" do
      expect(html_publication.historically_political?).to be(true)
      expect(html_publication.publishing_government).to eq("2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  it "is not withdrawn" do
    expect(html_publication.withdrawn?).to be(false)
  end

  context "when content has been withdrawn" do
    let(:content_store_response) do
      GovukSchemas::Example.find("html_publication", example_name: "published").tap do |example|
        example["withdrawn_notice"] = {
          withdrawn_at: "2020",
          explanation: "because of a reason",
        }.deep_stringify_keys
      end
    end

    it "returns the appropriate information" do
      expect(html_publication.withdrawn?).to be(true)
      expect(html_publication.withdrawn_at).to eq("2020")
      expect(html_publication.withdrawn_explanation).to eq("because of a reason")
    end
  end
end
