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

    it "has a search box" do
      within ".gem-c-search" do
        expect(page).to have_text(I18n.t("formats.manuals.search_this_manual"))
      end
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
  end
end

  # test "renders metadata" do
  #   setup_and_visit_manual_section

  #   assert_has_metadata(
  #     {
  #       from: { "Government Digital Service": "/government/organisations/government-digital-service" },
  #       first_published: "27 April 2015",
  #       other: {
  #         I18n.t("manuals.see_all_updates") => "#{@manual['base_path']}/updates",
  #       },
  #     },
  #     extra_metadata_classes: ".gem-c-metadata--inverse",
  #   )
  # end

  # test "renders back link" do
  #   setup_and_visit_manual_section

  #   assert page.has_link?(I18n.t("manuals.breadcrumb_contents"), href: @manual["base_path"])
  # end

  # test "renders content lists if published by MOJ" do
  #   content_item = get_content_example("what-is-content-design")
  #   organisations = { "organisations" => [{ "content_id" => "dcc907d6-433c-42df-9ffb-d9c68be5dc4d" }] }
  #   content_item["links"] = content_item["links"].merge(organisations)

  #   setup_and_visit_manual_section(content_item)

  #   assert_has_contents_list([
  #     { text: "Designing content, not creating copy", id: "designing-content-not-creating-copy" },
  #     { text: "Content design always starts with user needs", id: "content-design-always-starts-with-user-needs" },
  #   ])
  # end
