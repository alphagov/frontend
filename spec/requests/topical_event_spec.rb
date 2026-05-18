RSpec.describe "Topical event page" do
  include GdsApi::TestHelpers::Search

  let(:base_path) { content_item.fetch("base_path") }
  let(:search_response) do
    {
      "results" => [
        {
          "title" => "An announcement on Topicals",
          "link" => "/foo/announcement_one",
          "display_type" => "some_display_type",
          "public_timestamp" => "2025-12-01T00:00:01Z",
        },
      ],
    }
  end

  describe "GET show" do
    let(:content_item) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }

    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
      stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
        .to_return(body: search_response.to_json)
      get base_path
    end

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "includes an impact header flexible section" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_impact_header")
    end

    it "includes a govspeak flexible section with the body" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_govspeak")
    end

    it "includes a link flexible section to the about page" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_link")
    end

    it "includes a document list flexible section" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_document_list")
    end

    it "includes a share flexible section" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_share")
    end

    it "includes an involved flexible section" do
      expect(response).to render_template(partial: "flexible_page/flexible_sections/_involved")
    end
  end

  describe "GET show (atom format)" do
    let(:content_item) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }

    before do
      stub_conditional_loader_returns_content_item_for_path("#{base_path}.atom", content_item)
      stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
        .to_return(body: search_response.to_json)
      get "#{base_path}.atom?graphql=false"
    end

    it "returns 200" do
      expect(response).to have_http_status(:ok)
    end

    it "returns correct content-type" do
      expect(response.headers["Content-Type"]).to eq("application/atom+xml; charset=utf-8")
    end

    it "sets the cache-control headers to 5 mins" do
      expect(response.headers["Cache-Control"]).to eq("max-age=#{5.minutes.to_i}, public")
    end

    it "sets the Access-Control-Allow-Origin header" do
      expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
    end
  end
end
