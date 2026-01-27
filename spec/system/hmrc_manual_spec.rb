RSpec.describe "Hmrc manual" do
  context "when visiting a HMRC manual page" do
    let(:content_item) { GovukSchemas::Example.find(:hmrc_manual, example_name: "vat-government-public-bodies") }
    let(:base_path) { content_item["base_path"] }

    before do
      stub_content_store_has_item(base_path, content_item)
      visit base_path
    end

    it "displays the title" do
      expect(page).to have_title(content_item["title"])
    end

    it "displays the description" do
      expect(page).to have_text(content_item["description"])
    end

    it "displays the manual type" do
      within "#manual-title" do
        expect(page).to have_text(I18n.t("formats.manuals.hmrc_manual_type"))
      end
    end

    it "renders the relevant metadata" do
      within("[class*='gem-c-inverse-header']") do
        expect(page).to have_text("From: HM Revenue & Customs")
        expect(page).to have_link("HM Revenue & Customs", href: "/government/organisations/hm-revenue-customs")
        expect(page).to have_text("Published 11 February 2015")
        expect(page).to have_text("Updated: 11 February 2015")
      end
    end

    it "renders search box" do
      within(".gem-c-search") do
        expect(page).to have_text("Search this manual")
      end
    end

    it "renders 'Summary' title if description field is present" do
      expect(page).to have_css("h2", text: "Summary")
    end

    it "renders contents title heading" do
      expect(page).to have_css("h2", text: "Contents")
    end

    it "renders sections title heading" do
      expect(page).to have_css("h3", text: "Historic updates")
    end

    it "renders section groups" do
      child_section_groups = page.all(".subsection-collection .section-list")
      expect(child_section_groups.count).to eq(2)
    end

    it "renders child section groups" do
      child_section_groups = page.all(".subsection-collection .section-list")

      within child_section_groups[0] do
        first_group_children = page.all("li")
        expect(first_group_children.count).to eq(9)

        within first_group_children[0] do
          expect(page).to have_link("Introduction: contents", href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000")
          expect(page).to have_text("VATGPB1000")
        end
      end

      within child_section_groups[1] do
        section_group_children = page.all("li")
        expect(section_group_children.count).to eq(1)

        within section_group_children[0] do
          expect(page).to have_link("VAT Government and public bodies: update index", href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpbupdate001")
          expect(page).to have_text("VATGPBUPDATE001")
        end
      end
    end
  end

  # test "does not render section groups with no sections inside" do
  #   content_item_override = {
  #     "details" => {
  #       "child_section_groups" => [
  #         {
  #           title: "Some section group title 1",
  #           child_sections: [],
  #         },
  #         {
  #           title: "Some section group title 2",
  #           child_sections: [
  #             {
  #               "section_id" => "VATGPB1000",
  #               "title" => "Introduction: contents",
  #               "description" => "",
  #               "base_path" => "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
  #             },
  #           ],
  #         },
  #       ],
  #     },
  #   }

  #   setup_and_visit_content_item("vat-government-public-bodies", content_item_override)
  #   assert page.has_no_text?("Some section group title 1")
  #   assert page.has_text?("Some section group title 2")
  # end
end
