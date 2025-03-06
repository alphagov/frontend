RSpec.describe "Get Involved" do
  before do
    content_store_has_example_item("/government/get-involved", schema: :get_involved)
    stub_search_query(query: hash_including(filter_content_store_document_type: "open_consultation"), response: { "results" => [], "total" => 83 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "closed_consultation"), response: { "results" => [], "total" => 110 })
    stub_search_query(query: hash_including(filter_content_store_document_type: "consultation_outcome"), response: { "results" => [consultation_result] })
    visit "/government/get-involved"
  end

  it_behaves_like "it has meta tags", "get_involved", "get_involved"

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

    it "does not display a single page notification button" do
      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end

    it "shows date of last update" do
      expect(page).to have_text("Updated: 2 January 2022")
    end

    it "shows closing date" do
      expect(page).to have_text("Closed: 8 February 2023")
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
    "public_timestamp" => "2022-01-02T00:00:00.000+00:00",
    "end_date" => "2023-02-08T00:00:00.000+00:00",
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
