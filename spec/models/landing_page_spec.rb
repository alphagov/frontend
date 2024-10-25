RSpec.describe LandingPage do
  let(:details) do
    {}
  end

  let(:links) do
    {}
  end

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
        "details" => details,
        "links" => links,
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

  describe "#collection_groups" do
    context "is a document collection" do
      # The landing page has both collection_groups and links / documents
      let(:details) do
        {
          "blocks" => [],
          "collection_groups" => [
            {
              "title" => "collection group 1",
              "documents" => %w[
                00000000-0000-0000-0000-000000000000
              ],
            },
            {
              "title" => "collection group 2",
              "documents" => %w[
                00000000-0000-0000-0000-000000000001
                00000000-0000-0000-0000-000000000002
              ],
            }
          ]
        }
      end

      let(:links) do
        {
          "documents" => [
            {
              "base_path" => "/some-base-path-1",
              "content_id" => "00000000-0000-0000-0000-000000000000",
              "title" => "Some document 1",
            },
            {
              "base_path" => "/some-base-path-2",
              "content_id" => "00000000-0000-0000-0000-000000000001",
              "title" => "Some document 2",
            },
            {
              "base_path" => "/some-base-path-3",
              "content_id" => "00000000-0000-0000-0000-000000000002",
              "title" => "Some document 3",
            },
          ]
        }
      end

      it "expands collection groups" do
        expect(described_class.new(content_item).collection_groups).to match(
          "collection group 1" => an_instance_of(DocumentCollectionGroup),
          "collection group 2" => an_instance_of(DocumentCollectionGroup),
        )
      end
    end
  end
end
