RSpec.describe "HMRC Manual Section" do
  let(:content_item) { GovukSchemas::Example.find(:hmrc_manual_section, example_name: "vatgpb2000") }
  let(:base_path) { content_item["base_path"] }
  let(:manual_content_item) { GovukSchemas::Example.find(:hmrc_manual, example_name: "vat-government-public-bodies") }

  before do
    stub_content_store_has_item(base_path, content_item)
    stub_content_store_has_item(content_item["details"]["manual"]["base_path"], manual_content_item)
    stub_content_store_has_item("/hmrc-internal-manuals/vat-government-public-bodiesg/dmbm510100", content_item)

    visit base_path
  end

  it "has a title" do
    expect(page).to have_title(content_item["title"])
  end

  it "includes the description" do
    expect(page).to have_text(content_item["description"])
  end

  it "displays the manual type" do
    within "#manual-title" do
      expect(page).to have_text(I18n.t("formats.manuals.hmrc_manual_type"))
    end
  end

  it "displays the metadata" do
    within(".gem-c-metadata") do
      expect(page).to have_text("From: HM Revenue & Customs")
      expect(page).to have_link("HM Revenue & Customs", href: "/government/organisations/hm-revenue-customs")
      expect(page).to have_content("Published 11 February 2015")
      expect(page).to have_link(I18n.t("formats.manuals.see_all_updates"), href: "#{manual_content_item['base_path']}/updates")
    end
  end

  it "has a search box" do
    within ".gem-c-search" do
      expect(page).to have_text(I18n.t("formats.manuals.search_this_manual"))
    end
  end

  it "has the back link breadcrumb" do
    expect(page).to have_link(I18n.t("formats.manuals.breadcrumb_contents"), href: "/hmrc-internal-manuals/vat-government-and-public-bodies")
  end

  context "when the content item has breadcrumbs" do
    let(:content_item) do
      GovukSchemas::Example.find(:hmrc_manual_section, example_name: "vatgpb2000").tap do |item|
        item["details"]["breadcrumbs"] = [
          {
            base_path: "/hmrc-internal-manuals/debt-management-and-banking/dmbm510000",
            section_id: "DMBM510000",
          },
          {
            base_path: "/hmrc-internal-manuals/vat-government-public-bodiesg/dmbm510100",
            section_id: "DMBM510100",
          },
        ]
      end
    end

    it "has the specified breadcrumb links" do
      expect(page).to have_link(I18n.t("formats.manuals.breadcrumb_contents"), href: "/hmrc-internal-manuals/vat-government-and-public-bodies")
      expect(page).to have_link("DMBM510000", href: "/hmrc-internal-manuals/debt-management-and-banking/dmbm510000")
    end
  end
end

  # test "renders section group" do
  #   setup_and_visit_manual_section

  #   within ".subsection-collection .section-list" do
  #     first_group_children = page.all("li")

  #     assert_equal 6, first_group_children.count

  #     within first_group_children[0] do
  #       assert page.has_link?(
  #         "Introduction: scope of the manual",
  #         href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb2100",
  #       )
  #       assert page.has_text?("VATGPB2100")
  #     end
  #   end
  # end

  # test "renders previous and next navigation" do
  #   setup_and_visit_manual_section

  #   within ".govuk-pagination" do
  #     assert page.has_link?(
  #       I18n.t("manuals.previous_page"),
  #       href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb1000",
  #     )

  #     assert page.has_link?(
  #       I18n.t("manuals.next_page"),
  #       href: "/hmrc-internal-manuals/vat-government-and-public-bodies/vatgpb3000",
  #     )
  #   end
  # end
