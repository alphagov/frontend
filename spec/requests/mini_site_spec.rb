RSpec.describe "Mini Site page" do
  include GdsApi::TestHelpers::Search

  let(:base_path) { content_item.fetch("base_path") }
  let(:content_item) { GovukSchemas::Example.find(schema_name, example_name:) }
  let(:example_name) { "mini-site" }
  let(:schema_name) { "mini_site" }

  let(:search_response) do
    {
      "results" => [
        {
          "title" => "An announcement on Mini Sites",
          "link" => "/foo/announcement_one",
          "display_type" => "some_display_type",
          "public_timestamp" => "2025-12-01T00:00:01Z",
        },
      ],
    }
  end

  before do
    stub_content_store_has_item("/government", {})
    stub_content_store_has_item(base_path, content_item)
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
      .to_return(body: search_response.to_json)
  end

  describe "GET show" do
    before do
      get base_path
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end
end
