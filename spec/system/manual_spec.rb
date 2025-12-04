RSpec.describe "Manuals" do
  let(:content_store_response) { GovukSchemas::Example.find("manual", example_name: "content-design") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    stub_content_store_does_not_have_item("/guidance")
    visit base_path
    # puts page.body
  end

  context "when visiting a manual page" do
    it "displays the manual page title and description" do
      expect(page).to have_title(content_store_response["title"])
      expect(page).to have_css("h1", text: "Content design")
      expect(page).to have_text(content_store_response["description"])
    end

    it "has only one element with id `content`" do
      content_ids = page.all('[id="content"]')
      expect(content_ids.count).to eq(1)
    end

    it "renders the metadata" do
      within(".gem-c-metadata--inverse") do
        expect(page).to have_text("From:")
        expect(page).to have_link("Government Digital Service", href: "/government/organisations/government-digital-service")
        expect(page).to have_text("Published 27 April 2015")
        expect(page).to have_text("Updated:")
        expect(page).to have_link("See all updates", href: "#{base_path}/updates")
      end
    end
  end
end

#   test "renders metadata" do
#     setup_and_visit_content_item("content-design")

#     assert_has_metadata(
#       {
#         from: { "Government Digital Service": "/government/organisations/government-digital-service" },
#         first_published: "27 April 2015",
#         other: {
#           I18n.t("manuals.see_all_updates") => "#{@content_item['base_path']}/updates",
#         },
#       },
#       extra_metadata_classes: ".gem-c-metadata--inverse",
#     )
#   end

#   test "renders search box" do
#     setup_and_visit_content_item("content-design")

#     within ".gem-c-search" do
#       assert page.has_text?(I18n.t("manuals.search_this_manual"))
#     end
#   end

#   test "renders about title" do
#     setup_and_visit_content_item("content-design")

#     assert page.has_text?(I18n.t("manuals.summary_title"))
#   end

#   test "renders contents title heading" do
#     setup_and_visit_content_item("content-design")

#     assert page.has_selector?("h2", text: I18n.t("manuals.contents_title"))
#   end

#   test "renders body govspeak" do
#     setup_and_visit_content_item("content-design")

#     within ".gem-c-govspeak" do
#       assert page.has_text?("If you like yoga")
#     end
#   end

#   test "renders sections" do
#     setup_and_visit_content_item("content-design")

#     within ".gem-c-document-list" do
#       list_items = page.all(".gem-c-document-list__item")

#       assert_equal 3, list_items.count

#       within list_items[0] do
#         assert page.has_link?("What is content design?", href: "/guidance/content-design/what-is-content-design")
#         assert page.has_text?("Introduction to content design.")
#       end
#     end
#   end
# end
