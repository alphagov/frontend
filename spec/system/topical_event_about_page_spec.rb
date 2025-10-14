RSpec.describe "Topical Event About Page" do
  let(:content_store_response) { GovukSchemas::Example.find("topical_event_about_page", example_name: "topical_event_about_page") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    visit base_path
  end

  describe "basic page information" do
    it "has a page title" do
      expect(page).to have_title(content_store_response["title"])
    end

    it "has a lead paragraph taken from the description" do
      expect(page).to have_text(content_store_response["title"])
    end

    it "has body text" do
      assert page.has_text?("The risk of Ebola to the UK remains low. The virus is only transmitted by direct contact with the blood or bodily fluids of an infected person.")
    end
  end

  describe "contents list" do
    context "when headers are present" do
      it "has a contents list" do
        expect(page).to have_selector(".gem-c-contents-list", text: "Contents")

        expected_headers = [
          { text: "Response in the UK", id: "response-in-the-uk" },
          { text: "Response in Africa", id: "response-in-africa" },
          { text: "Advice for travellers", id: "advice-for-travellers" },
        ]

        within ".gem-c-contents-list" do
          expected_headers.each do |heading|
            selector = "a[href=\"##{heading[:id]}\"]"
            text = heading.fetch(:text)
            expect(page).to have_selector(selector)
            expect(page).to have_selector(selector, text:)
          end
        end
      end
    end

    context "when headers are not present" do
      let(:content_store_response) { GovukSchemas::Example.find("topical_event_about_page", example_name: "slim") }

      it "doesn't have a contents list" do
        expect(page).not_to have_selector(".contents-list.contents-list-dashed")
      end
    end
  end

#   test "contents list displayed when fewer than three items and first item word count is greater than 100" do
#     @content_item = get_content_example("topical_event_about_page")
#     @content_item["details"]["body"] = long_first_item_body

#     stub_content_store_has_item(@content_item["base_path"], @content_item.to_json)

#     visit_with_cachebust @content_item["base_path"]
#     assert page.has_css?(".gem-c-contents-list")
#   end

#   test "does not render with the single page notification button" do
#     setup_and_visit_content_item("topical_event_about_page")
#     assert_not page.has_css?(".gem-c-single-page-notification-button")
#   end

# private

#   def topical_event_end_date
#     Date.parse(@content_item["links"]["parent"][0]["details"]["end_date"])
#   end

#   def long_first_item_body
#     "<div class='govspeak'><h2 id='response-in-the-uk'>Item 1</h2>
#     <p>#{Faker::Lorem.characters(number: 200)}</p>
#     <p>#{Faker::Lorem.characters(number: 216)}</p>
#     <h2 id='response-in-africa'>Item 2</h2>
#     <p>#{Faker::Lorem.sentence}</p></div>"
#   end

#   def body_with_two_contents_list_items
#     "<div class='govspeak'>
#     <h2 id='response-in-the-uk'>Item 1</h2>
#     <p>Content about item 1</p>
#     <h2 id='response-in-africa'>Item 2</h2>
#     <p>Content about item 2</p></div>"
#   end
end
