RSpec.describe "Topical event page" do
  include GdsApi::TestHelpers::Search

  let(:base_path) { content_item.fetch("base_path") }
  let(:content_item) { GovukSchemas::Example.find("topical_event", example_name: "topical-event-with-about-page") }
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

  before do
    stub_conditional_loader_returns_content_item_for_path(base_path, content_item)
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
      .to_return(body: search_response.to_json)
  end

  describe "GET show" do
    before { get base_path }

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end
  end

  describe "GET about" do
    let(:base_path) { "#{content_item.fetch('base_path')}/about" }

    before { get base_path }

    it "succeeds" do
      expect(response).to have_http_status(:ok)
    end

    it "renders the about template" do
      expect(response).to render_template(:about)
    end
  end

  describe "GET show (atom format)" do
    let(:base_path) { "#{content_item.fetch('base_path')}.atom" }

    before { get "#{base_path}?graphql=false" }

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
