RSpec.describe LandingPage do
  let(:content_item) do
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
    }
  end

  describe "#blocks" do
    before do
      stub_const("LandingPage::ADDITIONAL_CONTENT_PATH", "spec/fixtures")
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
  end
end
