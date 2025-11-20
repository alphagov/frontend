RSpec.describe HtmlPublication do
  subject(:html_publication) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "published") }

  it "returns a parent" do
    expect(html_publication.parent.content_id).to eq("8b19c238-54e3-4e27-b0d7-60f8e2a677c9")
  end

  it "returns public timestamp" do
    expect(html_publication.public_timestamp).to eq("2016-01-17T14:19:42.460Z")
  end

  it "returns first published version" do
    expect(html_publication.first_published_version).to be(true)
  end

  it_behaves_like "it can be withdrawn", "html_publication", "withdrawn"

  context "when there are no headers" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "prime_ministers_office") }

    it "return an empty array" do
      expect(described_class.new(content_store_response).headers.count).to eq(0)
    end
  end

  context "when the page contains headers" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "multiple_organisations") }

    it "returns an array of headers" do
      expect(described_class.new(content_store_response).headers.count).to eq(4)
      expect(described_class.new(content_store_response).headers[3]["headers"].count).to eq(1)
    end
  end

  it "returns copyright year" do
    expect(described_class.new(content_store_response).copyright_year).to eq(2016)
  end

  context "when there is no public timestamp" do
    let(:content_store_response) do
      GovukSchemas::Example.find("html_publication", example_name: "print_with_meta_data").tap do |example|
        example["details"]["public_timestamp"] = nil
      end
    end

    it "does not error" do
      expect { described_class.new(content_store_response).copyright_year }.not_to raise_error
    end
  end

  context "when there is an isbn" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "print_with_meta_data") }

    it "returns isbn" do
      expect(described_class.new(content_store_response).isbn).to eq("978-1-4098-4066-4")
    end
  end

  it "returns the govspeak content" do
    expect(described_class.new(content_store_response).body).to include("The Environment Agency has received a new bespoke application for an environmental permit under the Environmental Permitting (England and Wales) Regulations 2010 from Mr Derek Mears.")
  end
end
