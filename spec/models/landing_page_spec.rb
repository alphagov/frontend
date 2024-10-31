RSpec.describe LandingPage do
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
        "details" => {},
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

  before do
    stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
  end

  describe "#blocks" do
    before do
      @blocks_content = YAML.load_file(Rails.root.join("spec/fixtures/landing_page.yaml"))
    end

    it "builds all of the blocks" do
      expected_size = @blocks_content["blocks"].count

      expect(described_class.new(content_item).blocks.count).to eq(expected_size)
    end

    it "builds blocks of the correct type" do
      expected_type = @blocks_content["blocks"].first["type"]

      expect(described_class.new(content_item).blocks.first.type).to eq(expected_type)
    end

    it "loads blocks from the content item if present instead of using hardcoded data" do
      expect(build(:landing_page_with_one_block).blocks.count).to eq(1)
    end
  end

  describe "#navigation_groups" do
    it "returns a map of navigation_groups" do
      expect(described_class.new(content_item).navigation_groups["Top Menu"]["id"]).to eq("Top Menu")
      expect(described_class.new(content_item).navigation_groups["Top Menu"]["links"].count).to eq(2)
      expect(described_class.new(content_item).navigation_groups["Top Menu"]["links"][1]["links"].count).to eq(2)
    end
  end
end
