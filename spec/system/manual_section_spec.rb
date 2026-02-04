RSpec.describe "Manual Section" do
  context "when visiting a manual section" do
    let(:content_item) { GovukSchemas::Example.find(:manual_section, example_name: "what-is-content-design") }
    let(:base_path) { content_item["base_path"] }
    let(:manual_content_item) { GovukSchemas::Example.find(:manual, example_name: "content-design") }

    before do
      stub_content_store_has_item(base_path, content_item)
      stub_content_store_has_item(manual_content_item["base_path"], manual_content_item)
      visit base_path
    end

    it "has a title" do
      expect(page).to have_title(content_item["title"])
    end

    it "includes the description" do
      expect(page).to have_text(content_item["description"])
    end

    it "renders contextual breadcrumbs from the parent manuals tagging" do
      manual_taxonomy_topic = manual_content_item["links"]["taxons"].first

      within ".gem-c-contextual-breadcrumbs" do
        expect(page).to have_link(manual_taxonomy_topic["title"], href: manual_taxonomy_topic["base_path"])
      end
    end

    it "displays the metadata" do
      within(".gem-c-metadata") do
        expect(page).to have_text("From: Government Digital Service")
        expect(page).to have_link("Government Digital Service", href: "/government/organisations/government-digital-service")
        expect(page).to have_content("Published 27 April 2015")
        expect(page).to have_link(I18n.t("formats.manuals.see_all_updates"), href: "#{manual_content_item['base_path']}/updates")
      end
    end

    it "has a search box" do
      within ".gem-c-search" do
        expect(page).to have_text(I18n.t("formats.manuals.search_this_manual"))
      end
    end

    it "has a back link" do
      expect(page).to have_link(I18n.t("formats.manuals.breadcrumb_contents"), href: manual_content_item["base_path"])
    end

    it "has a document heading" do
      within "#manual-title .govuk-heading-l" do
        expect(page).to have_text(manual_content_item["title"])
      end
    end

    describe "body rendering" do
      it "has sections in accordion components" do
        expect(page).to have_css(".gem-c-accordion")

        accordion_sections = page.all(".govuk-accordion__section")
        expect(accordion_sections.count).to eq(7)

        within accordion_sections[0] do
          expect(page).to have_text("Designing content, not creating copy")
        end
      end

      context "when visually_expanded is set true in the content item" do
        let(:content_item) do
          GovukSchemas::Example.find(:manual_section, example_name: "what-is-content-design").tap do |item|
            item["details"]["visually_expanded"] = "true"
          end
        end

        it "renders without accordions" do
          within "#manuals-frontend" do
            expect(page.all("h2").count).to eq 7
            expect(page.all("h2").first.text).to eq("Designing content, not creating copy")
          end
        end
      end
    end

    describe "contents list rendering" do
      it "does not have a contents list" do
        expect(page).not_to have_selector(".gem-c-contents-list")
      end

      context "when the manual is published by the MoJ" do
        let(:content_item) do
          GovukSchemas::Example.find(:manual_section, example_name: "what-is-content-design").tap do |item|
            item["links"]["organisations"][0]["content_id"] = "dcc907d6-433c-42df-9ffb-d9c68be5dc4d"
          end
        end

        it "has a contents list" do
          expect(page).to have_contents_list([
            { text: "Designing content, not creating copy", id: "designing-content-not-creating-copy" },
            { text: "Content design always starts with user needs", id: "content-design-always-starts-with-user-needs" },
          ])
        end
      end
    end
  end
end
