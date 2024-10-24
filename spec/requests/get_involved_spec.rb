RSpec.describe "Get Involved" do
  before do
    stub_content_store_has_item("/government/get-involved", GovukSchemas::Example.find("get_involved", example_name: "get_involved"))
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"), response: { "results" => [], "total" => 83 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"), response: { "results" => [], "total" => 110 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"), response: { "results" => [consultation_result] })
  end

  context "GET index" do
    it "responds with success" do
      get "/government/get-involved"
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Get Involved")
    end
  end
end

def stub_search_query(query:, response:)
  stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
    .with(query:)
    .to_return(body: response.to_json)
end

def consultation_result
  {
    "title" => "Consulting on time zones",
    "public_timestamp" => "2022-02-14T00:00:00.000+01:00",
    "end_date" => "2022-02-14T00:00:00.000+01:00",
    "link" => "/consultation/link",
    "organisations" => [{
      "slug" => "ministry-of-justice",
      "link" => "/government/organisations/ministry-of-justice",
      "title" => "Ministry of Justice",
      "acronym" => "MoJ",
      "organisation_state" => "live",
    }],
  }
end
