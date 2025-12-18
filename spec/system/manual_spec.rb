RSpec.describe "Manual" do
  let(:content_store_response) { GovukSchemas::Example.find("manual", example_name: "content-design") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    stub_content_store_does_not_have_item("/guidance")
    visit base_path
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

    it "renders a search box" do
      within ".gem-c-search" do
        expect(page).to have_css("label.gem-c-search__label", text: "Search this manual")
      end
    end

    it "renders the summary title" do
      expect(page).to have_css("h2.gem-c-heading__text", text: "Summary")
    end

    it "renders the contents title heading" do
      expect(page).to have_css("h2.gem-c-heading__text", text: "Contents")
    end

    it "renders the body content using Govspeak" do
      within ".gem-c-govspeak" do
        expect(page).to have_text("If you like yoga")
      end
    end

    it "renders the sections list" do
      within ".gem-c-document-list" do
        list_items = page.all(".gem-c-document-list__item")
        expect(list_items.count).to eq(3)

        within list_items[0] do
          expect(page).to have_link("What is content design?", href: "/guidance/content-design/what-is-content-design")
          expect(page).to have_text("Introduction to content design.")
        end
      end
    end
  end
end
