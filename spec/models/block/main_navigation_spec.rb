RSpec.describe Block::MainNavigation do
  let(:blocks_hash) do
    {
      "type" => "main_navigation",
      "title" => "Service Name",
      "title_link" => "https://www.gov.uk",
      "collection_group_name" => "Top menu"
    }
  end

  # TODO - this is a lot of setup to be putting in block tests... factor it out?
  let(:content_item) do
    http_response = instance_double(RestClient::Response)
    allow(http_response).to receive(:body).and_return(
      {
        "base_path" => "/landing-page",
        "title" => "Landing Page",
        "description" => "A landing page example",
        "locale" => "en",
        "document_type" => "landing_page",
        "schema_name" => "landing_page",
        "publishing_app" => "whitehall",
        "rendering_app" => "frontend",
        "update_type" => "major",
        "details" => {
          "blocks" => []
        },
        "routes" => [
          {
            "type" => "exact",
            "path" => "/landing-page",
          },
        ],
      }.to_json,
      )
    GdsApi::Response.new(http_response)
  end

  let(:landing_page) { LandingPage.new(content_item) }

  describe "#title" do
    it "returns a title and title_link" do
      result = described_class.new(blocks_hash, landing_page)
      expect(result.title).to eq "Service Name"
      expect(result.title_link).to eq "https://www.gov.uk"
    end
  end

  describe "#links" do
    it "returns an array of links" do
      result = described_class.new(blocks_hash, landing_page).links
      expect(result.size).to eq 2
      expect(result.first).to eq({ "text" => "Test 1", "href" => "/hello" })
      expect(result.second).to eq({
        "text" => "Test 2",
        "href" => "/goodbye",
        "items" => [
          {
            "text" => "Child a",
            "href" => "/a",
          },
          {
            "text" => "Child b",
            "href" => "/b",
          },
        ],
      })
    end
  end

  describe "#full_width?" do
    it "is true" do
      expect(described_class.new(blocks_hash, landing_page).full_width?).to eq(true)
    end
  end
end
