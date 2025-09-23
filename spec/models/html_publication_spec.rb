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

  it "when content has no national applicability it doesn't return anything" do
    expect(html_publication.national_applicability).to be_nil
  end

  context "when content has national applicability" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "national_applicability_alternative_url_html_publication") }

    it "returns applicability information" do
      expected = {
        england: {
          applicable: true,
          label: "England",
        },
        northern_ireland: {
          alternative_url: "http://www.dardni.gov.uk/news-dard-pa022-a-13-new-procedure-for",
          applicable: false,
          label: "Northern Ireland",
        },
        scotland: {
          applicable: true,
          label: "Scotland",
        },
        wales: {
          applicable: true,
          label: "Wales",
        },
      }
      expect(html_publication.national_applicability).to eq(expected)
    end
  end

  context "when there are no headers" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "published") }

    it "return an empty array" do
      expect(described_class.new(content_store_response).headers.count).to eq(0)
    end
  end

  context "when the page contains headers" do
    let(:content_store_response) do
      GovukSchemas::Example.find("html_publication", example_name: "published").tap do |example|
        example["details"]["headers"] = [
          {
            "headers": [
              {
                "id": "important-dates",
                "level": 3,
                "text": "1.1 Important dates",
              },
              {
                "id": "scheme-changes-for-2024",
                "level": 3,
                "text": "1.2 Scheme changes for 2024",
              },
            ],
            "id": "important-dates-and-scheme-changes",
            "level": 2,
            "text": "1. Important dates and scheme changes",
          }.deep_stringify_keys,
        ]
      end
    end

    it "returns an array of headers" do
      expect(described_class.new(content_store_response).headers.count).to eq(1)
      expect(described_class.new(content_store_response).headers.first["headers"].count).to eq(2)
    end
  end

  it "returns copyright year" do
    expect(described_class.new(content_store_response).copyright_year).to eq(2016)
  end

  context "when there is an isbn" do
    let(:content_store_response) { GovukSchemas::Example.find("html_publication", example_name: "print_with_meta_data") }

    it "returns isbn" do
      expect(described_class.new(content_store_response).isbn).to eq("978-1-4098-4066-4")
    end
  end

  it "returns the govspeak content" do
    expect(described_class.new(content_store_response).govspeak_body).to include("The Environment Agency has received a new bespoke application for an environmental permit under the Environmental Permitting (England and Wales) Regulations 2010 from Mr Derek Mears.")
  end
end
