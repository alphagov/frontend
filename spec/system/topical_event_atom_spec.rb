RSpec.describe "Topical Event Atom Feed" do
  include GdsApi::TestHelpers::Search

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
  let(:base_path) { "#{content_store_response.fetch('base_path')}.atom" }
  let(:response) do
    {
      "results" => [
        {
          "title" => "An announcement on Topicals",
          "link" => "/foo/announcement_one",
          "display_type" => "some_display_type",
          "public_timestamp" => "2025-12-01T00:00:01Z",
        },
        {
          "title" => "Another announcement",
          "link" => "/foo/announcement_two",
          "display_type" => "some_display_type",
          "public_timestamp" => "2025-12-01T00:00:01Z",
        },
      ],
    }
  end

  before do
    stub_content_store_has_item(base_path, content_store_response)
    stub_request(:get, /\A#{Plek.new.find('search-api')}\/search.json/)
      .to_return(body: response.to_json)
    visit base_path
  end

  it "sets the page title" do
    expect(page).to have_title("#{content_store_response['title']} - Activity on GOV.UK")
  end

  it "includes the correct entries" do
    entries = Hash.from_xml(page.html).dig("feed", "entry")

    expect(entries.first).to include("title" => "some_display_type: An announcement on Topicals")
    expect(entries.first["link"]).to include("href" => "http://www.dev.gov.uk/foo/announcement_one")

    expect(entries.second).to include("title" => "some_display_type: Another announcement")
    expect(entries.second["link"]).to include("href" => "http://www.dev.gov.uk/foo/announcement_two")
  end
end
