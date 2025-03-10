RSpec.describe "Get Involved" do
  before do
    stub_content_store_has_item("/government/get-involved", GovukSchemas::Example.find("get_involved", example_name: "get_involved"))
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/).to_return(body: { "results" => [], "total" => 83 }.to_json)
  end

  describe "GET index" do
    it "responds with success" do
      get "/government/get-involved"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Get involved")
    end
  end
end
