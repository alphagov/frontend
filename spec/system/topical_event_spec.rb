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

  # it "sets the body text" do
  #   visit base_path
  #   expect(page).to have_text(content_item.dig("details", "body"))
  # end

  # it "includes a link to signup for emails" do
  #   visit base_path
  #   expect(page).to have_link("Get emails", href: "/email-signup?link=/government/topical-events/something-very-topical")
  # end

  # context "documents list" do
  #   let(:related_consultations) { { "A consultation on Topicals" => "/foo/consultation_one", "Another consultation" => "/foo/consultation_two" } }
  #   let(:related_announcements) { { "An announcement on Topicals" => "/foo/announcement_one", "Another announcement" => "/foo/announcement_two" } }
  #   let(:related_guidance_and_regulation) { { "Some guidance" => "/foo/detailed_guidance_one", "Another bit of guidance" => "/foo/detailed_guidance_two" } }

  #   context "related publications" do
  #     let(:related_publications) { { "Policy on Topicals" => "/foo/policy_paper", "PM attends summit on topical events" => "/foo/news_story" } }

  #     xit "displays related publications" do
  #       stub_search(body: search_api_response(related_publications), params: { "filter_format" => "publication" })

  #       visit base_path

  #       expect(page).to have_text("Publications")

  #       within("#publications") do
  #         related_publications.each { |title, link| expect(page).to have_link(title, href: link) }
  #         expect(page).to have_link("See all publications", href: "/search/all?topical_events%5B%5D=something-very-topical")
  #       end
  #     end
  #   end

  #   it "displays links to all related documents" do
  #     stub_search(body: search_api_response(related_announcements), params: { "filter_content_purpose_supergroup" => "news_and_communications" })
  #     stub_search(body: search_api_response(related_consultations), params: { "filter_format" => "consultation" })
  #     stub_search(body: search_api_response(related_guidance_and_regulation), params: { "filter_content_purpose_supergroup" => "guidance_and_regulation" })

  #     visit base_path

  #     expect(page).to have_text("Documents")
  #     expect(page).to have_text("Consultations")
  #     expect(page).to have_text("Announcements")
  #     expect(page).to have_text("Guidance and regulation")

  #     within("#consultations") do
  #       related_consultations.each { |title, link| expect(page).to have_link(title, href: link) }
  #       expect(page).to have_link("See all consultations", href: "/search/policy-papers-and-consultations?content_store_document_type%5B%5D=open_consultations&content_store_document_type%5B%5D=closed_consultations&topical_events%5B%5D=something-very-topical")
  #     end

  #     within("#announcements") do
  #       related_announcements.each { |title, link| expect(page).to have_link(title, href: link) }
  #       expect(page).to have_link("See all announcements", href: "/search/news-and-communications?topical_events%5B%5D=something-very-topical")
  #     end

  #     within("#guidance-and-regulation") do
  #       related_guidance_and_regulation.each { |title, link| expect(page).to have_link(title, href: link) }
  #       expect(page).to have_link("See all guidance and regulation", href: "/search/all?content_purpose_supergroup=guidance_and_regulation&topical_events%5B%5D=something-very-topical")
  #     end
  #   end

  #   it "doesn't display any document headers when there are no related documents" do
  #     visit base_path

  #     expect(page).not_to have_text("Publications")
  #     expect(page).not_to have_text("Announcements")
  #     expect(page).not_to have_text("Consultations")
  #     expect(page).not_to have_text("Documents")
  #     expect(page).not_to have_text("Detailed Guides")
  #   end

  #   it "displays links to all related documents with GA4 tracking" do
  #     stub_search(body: search_api_response(related_announcements), params: { "filter_content_purpose_supergroup" => "news_and_communications" })
  #     stub_search(body: search_api_response(related_consultations), params: { "filter_format" => "consultation" })
  #     stub_search(body: search_api_response(related_guidance_and_regulation), params: { "filter_content_purpose_supergroup" => "guidance_and_regulation" })

  #     visit base_path

  #     within("#consultations") do
  #       ga4_link_data = JSON.parse(page.first("a[data-module='ga4-link-tracker']")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "section" => "Consultations", "type" => "see all" })
  #     end

  #     within("#announcements") do
  #       ga4_link_data = JSON.parse(page.first("a[data-module='ga4-link-tracker']")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "section" => "Announcements", "type" => "see all" })
  #     end

  #     within("#guidance-and-regulation") do
  #       ga4_link_data = JSON.parse(page.first("a[data-module='ga4-link-tracker']")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "section" => "Guidance and regulation", "type" => "see all" })
  #     end
  #   end
  # end

  # context "latest documents" do
  #   let(:latest_documents) { { "Some document" => "/foo/latest_one", "Another document" => "/foo/latest_two" } }

  #   it "displays the latest documents" do
  #     stub_search(body: search_api_response(latest_documents))

  #     visit base_path

  #     expect(page).to have_text("Latest")

  #     within("#latest") do
  #       latest_documents.each { |title, link| expect(page).to have_link(title, href: link) }
  #       expect(page).to have_link("See all", href: "/search/all?order=updated-newest&topical_events%5B%5D=something-very-topical")
  #     end
  #   end

  #   it "has GA4 tracking on the 'see all' link" do
  #     stub_search(body: search_api_response(latest_documents))

  #     visit base_path

  #     within("#latest") do
  #       ga4_link_data = JSON.parse(page.first("a[data-module='ga4-link-tracker']")["data-ga4-link"])
  #       expect(ga4_link_data).to eq({ "event_name" => "navigation", "section" => "Latest", "type" => "see all" })
  #     end
  #   end

  #   it "displays a message when there are no documents yet" do
  #     stub_search(body: search_api_response({}))

  #     visit base_path

  #     expect(page).to have_text("Latest")

  #     within("#latest") do
  #       expect(page).to have_text("There are no updates yet.")
  #     end
  #   end
  # end

  # it "includes a link to the about page" do
  #   visit base_path
  #   expect(page).to have_link(content_item.dig("details", "about_page_link_text"), href: "#{base_path}/about")
  # end

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

  # context "when there are social media links" do
  #   it "includes links to the social media accounts" do
  #     visit base_path
  #     expect(page).to have_link("Facebook", href: "https://www.facebook.com/a-topical-event")
  #     expect(page).to have_link("Twitter", href: "https://www.twitter.com/a-topical-event")
  #   end
  # end

  # context "when there are no social media links" do
  #   before do
  #     stub_content_store_has_item(base_path, content_item_without_detail(content_item, "social_media_links"))
  #   end

  #   it "does not include links to any social media platforms" do
  #     visit base_path
  #     expect(page).to_not have_text("Facebook")
  #     expect(page).to_not have_text("Twitter")
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
