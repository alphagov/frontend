RSpec.describe "Topical Event pages" do
  include GdsApi::TestHelpers::Search

  let(:content_store_response) { GovukSchemas::Example.find("topical_event", example_name: "western-balkans-summit-london-2018") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    stub_any_search_to_return_no_results
    visit base_path
  end

  it "sets the page title" do
    expect(page).to have_title("#{content_store_response['title']} - GOV.UK")
  end

  it "sets the page description" do
    expect(page).to have_text(content_store_response["description"])
  end

  it "sets the page meta description" do
    expect(page).to have_selector("meta[name='description'][content='#{content_store_response['description']}']", visible: :hidden)
  end

  it "includes an impact header" do
    expect(page).to have_selector("[data-flexible-section='impact-header']")
  end

  it "sets the body text" do
    expect(page.html).to include(content_store_response.dig("details", "body"))
  end

  it "includes a link to the about page" do
    expect(page).to have_link(content_store_response.dig("details", "about_page_link_text"), href: "#{base_path}/about")
  end

  it "includes a feed" do
    expect(page).to have_selector("[data-flexible-section='feed']")
  end

  # context "when there are organisations" do
  #   it "includes a link to the organisation" do
  #     visit base_path
  #     expect(page).to have_link("Department of topical affairs", href: "government/organisations/department-for-topical-affairs")
  #   end

  #   it "includes GA4 tracking on the link to the organisation" do
  #     visit base_path
  #     within(".govuk-list[data-module='ga4-link-tracker']") do
  #       ga4_link_data = JSON.parse(page.first("div[data-ga4-link]")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "type" => "organisation logo", "index_link" => 1, "index_total" => 1, "section" => "Who’s involved" })
  #     end
  #   end
  # end

  # context "when there are no organisations" do
  #   before do
  #     stub_content_store_has_item(base_path, content_item_without_link(content_item, "organisations"))
  #   end

  #   it "does not include a link to the organisations" do
  #     visit base_path

  #     expect(page).to_not have_text("Organisations: ")
  #   end
  # end

  # context "when there are emphasised organisations" do
  #   it "includes logos for the emphasised organisations but not normal organisations" do
  #     visit base_path

  #     expect(page).to have_css(".gem-c-organisation-logo", count: 1)
  #   end
  # end

  # context "when there are featured documents" do
  #   it "includes the featured documents header" do
  #     visit base_path
  #     expect(page).to have_text(I18n.t("shared.featured"))
  #   end

  #   it "includes links to the featured documents" do
  #     visit base_path
  #     expect(page).to have_link("A document related to this event", href: "https://www.gov.uk/somewhere")
  #   end

  #   it "includes GA4 tracking on links to the featured documents" do
  #     visit base_path
  #     within("#featured") do
  #       ga4_link_data = JSON.parse(page.first("div[data-module='ga4-link-tracker'][data-ga4-track-links-only]")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "section" => "Featured", "type" => "image card" })
  #     end
  #   end
  # end

  # context "when there are no featured documents" do
  #   before do
  #     stub_content_store_has_item(base_path, content_item_without_detail(content_item, "ordered_featured_documents"))
  #   end

  #   it "does not include the featured documents header" do
  #     visit base_path
  #     expect(page).to_not have_text(I18n.t("shared.featured"))
  #   end
  # end

  # context "when requesting the atom feed" do
  #   let(:related_documents) { { "An announcement on Topicals" => "/foo/announcement_one", "Another announcement" => "/foo/announcement_two" } }

  #   before do
  #     stub_search(body: search_api_response(related_documents))
  #   end

  #   it "sets the page title" do
  #     visit "#{base_path}.atom"
  #     expect(page).to have_title("#{content_item['title']} - Activity on GOV.UK")
  #   end

  #   it "should include the correct entries" do
  #     visit "#{base_path}.atom"

  #     entries = Hash.from_xml(page.html).dig("feed", "entry")

  #     expect(entries.first).to include("title" => "some_display_type: An announcement on Topicals")
  #     expect(entries.first["link"]).to include("href" => "http://www.test.gov.uk/foo/announcement_one")

  #     expect(entries.second).to include("title" => "some_display_type: Another announcement")
  #     expect(entries.second["link"]).to include("href" => "http://www.test.gov.uk/foo/announcement_two")
  #   end
  # end

private

  # def content_item_without_detail(content_item, key_to_remove)
  #   content_item["details"] = content_item["details"].except(key_to_remove)
  #   content_item
  # end

  # def content_item_without_link(content_item, key_to_remove)
  #   content_item["links"] = content_item["links"].except(key_to_remove)
  #   content_item
  # end
end
