RSpec.describe ContentItemFactory do
  def fake_response(document_type, schema_name)
    http_response = instance_double(RestClient::Response)
    allow(http_response).to receive(:body).and_return(
      {
        "base_path" => "/example",
        "title" => "Example",
        "description" => "An example",
        "locale" => "en",
        "document_type" => document_type,
        "schema_name" => schema_name,
        "publishing_app" => "whitehall",
        "rendering_app" => "frontend",
        "update_type" => "major",
        "details" => {},
        "routes" => [
          {
            "type" => "exact",
            "path" => "/example",
          },
        ],
      }.to_json,
    )
    GdsApi::Response.new(http_response)
  end

  describe ".build" do
    it "builds ContentItems" do
      response = fake_response("generic", "generic")
      expect(described_class.build(response).class).to eq(ContentItem)
    end

    it "builds LandingPages" do
      response = fake_response("landing_page", "landing_page")
      expect(described_class.build(response).class).to eq(LandingPage)
    end

    it "builds LicenceTransactions" do
      response = fake_response("licence_transaction", "specialist_document")
      expect(described_class.build(response).class).to eq(LicenceTransaction)
    end
  end

  describe ".content_item_class" do
    it "defaults to ContentItem" do
      expect(described_class.content_item_class("generic")).to eq(ContentItem)
    end

    it "returns ContentItem even if given a nonsense schema name" do
      expect(described_class.content_item_class("무의미한 말")).to eq(ContentItem)
    end

    it "returns LandingPage for landing_page schemas" do
      expect(described_class.content_item_class("landing_page")).to eq(LandingPage)
    end
  end
end
