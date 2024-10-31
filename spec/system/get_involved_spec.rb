RSpec.describe "Get Involved" do
  it_behaves_like "it has meta tags", "get_involved", "/government/get-involved"
  before do
    content_store_has_example_item("/government/get-involved", schema: :get_involved)
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"), response: { "results" => [], "total" => 83 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"), response: { "results" => [], "total" => 110 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"), response: { "results" => [consultation_result] })
    visit "/government/get-involved"
  end

  context "when visiting get involved page" do
    it "displays the get involved page with the correct title" do
      expect(page).to have_title("Get involved - GOV.UK")
      expect(page).to have_css("h1", text: "Get Involved")
    end

    it "includes the correct number of open consultations" do
      expect(page).to have_selector(".gem-c-big-number", text: /83.+Open consultations/m)
    end

    it "includes the correct number of closed consultations" do
      expect(page).to have_selector(".gem-c-big-number", text: /110.+Closed consultations/m)
    end

    it "includes the next closing consultation" do
      expect(page).to have_text("Consulting on time zones")
    end

    it "shows the take part pages" do
      expect(page).to have_text("Volunteer")
      expect(page).to have_text("National Citizen Service")
    end

    it "does not display a single page notification button" do
      expect(page).not_to have_css(".gem-c-single-page-notification-button")
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
