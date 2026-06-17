RSpec.describe "Autocomplete API", type: :request do
  let(:search_api_v2) { instance_double(GdsApi::SearchApiV2, autocomplete: autocomplete_response) }

  let(:suggestions) { %w[blue grey red] }
  let(:autocomplete_response) { instance_double(GdsApi::Response, to_hash: { suggestions: }) }
  let(:params) { { q: "loving him was" } }

  before do
    allow(Services).to receive(:search_api_v2).and_return(search_api_v2)
  end

  it "returns suggestions from Search API v2" do
    get "/api/search/autocomplete", params: params

    expect(search_api_v2).to have_received(:autocomplete).with("loving him was")
    expect(response).to be_successful
    expect(JSON.parse(response.body)).to eq("suggestions" => suggestions)
  end

  it "fails if the query parameter is missing" do
    get "/api/search/autocomplete"

    expect(response).to have_http_status(:bad_request)
  end

  describe "CORS headers" do
    %w[
      https://www.gov.uk
      http://example.dev.gov.uk
      https://example.publishing.service.gov.uk
      https://preview-app-abcd123.herokuapp.com
    ].each do |allowed_host|
      it "returns CORS headers for #{allowed_host}" do
        get "/api/search/autocomplete", params:, headers: { Origin: allowed_host }

        expect(response.headers.to_h).to include({
          "access-control-allow-origin" => allowed_host,
          "access-control-allow-methods" => "GET",
        })
      end
    end

    it "returns CORS headers when there is a format extension on the path" do
      get "/api/search/autocomplete.json", params:, headers: { Origin: "https://www.gov.uk" }

      expect(response.headers)
        .to include("access-control-allow-origin", "access-control-allow-methods")
    end

    it "doesn't return CORS headers for an unsupported hosts" do
      get "/api/search/autocomplete", params:, headers: { Origin: "https://www.gov.uk.non-govuk.com" }

      expect(response.headers)
        .not_to include("access-control-allow-origin", "access-control-allow-methods")
    end
  end
end
