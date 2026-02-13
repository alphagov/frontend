RSpec.describe "Worldwide corporate information page" do
  let(:content_store_response) { GovukSchemas::Example.find("worldwide_corporate_information_page", example_name: "worldwide_corporate_information_page") }
  let(:base_path) { content_store_response.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_store_response)
    visit base_path
  end

  context "when visiting a worldwide corporate information page" do
    it "includes the title of the organisation" do
      expect(page).to have_title(content_store_response["title"])
    end

    it "omits breadcrumbs" do
      expect(page).not_to have_css(".govuk-breadcrumbs")
    end

    it "renders rtl text direction when the locale is a rtl language" do
      content_store_response["locale"] = "ar"
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
      expect(page).to have_css(".govuk-main-wrapper.direction-rtl")
    end

    it "includes the description" do
      expect(page).to have_text("The description for the worldwide corporate information page")
    end

    it "includes the logo and name of the worldwide organisation as a link" do
      expect(page).to have_css(".gem-c-organisation-logo")
      expect(page).to have_css("h1", text: "British EmbassyManila")
      expect(page).to have_link("British EmbassyManila", href: "/world/organisations/british-embassy-manila")
    end

    it "includes the world locations and sponsoring organisations" do
      within find(".worldwide-organisation-header__metadata", match: :first) do
        expect(page).to have_text("News:")
        expect(page).to have_link("Philippines with translation and the UK", href: "/world/philippines/news")
        expect(page).to have_link("Palau with translation and the UK", href: "/world/palau/news")

        expect(page).to have_text("Part of:")
        expect(page).to have_link("Foreign, Commonwealth & Development Office", href: "/government/organisations/foreign-commonwealth-development-office")
      end
    end
  end

  # test "includes the body and contents" do
  #   setup_and_visit_content_item("worldwide_corporate_information_page")

  #   assert page.has_content? "Contents"
  #   assert_has_contents_list([
  #     { text: "General information", id: "general-information" },
  #     { text: "Current work opportunities", id: "current-work-opportunities" },
  #   ])
  #   assert page.has_content?("Fair competition is at the centre of recruitment at the British Embassy Manila.")
  # end

  # test "omits the world locations and sponsoring organisations when they are absent" do
  #   content_item = get_content_example("worldwide_corporate_information_page")
  #   content_item["links"]["worldwide_organisation"][0]["links"]["sponsoring_organisations"] = nil
  #   content_item["links"]["worldwide_organisation"][0]["links"]["world_locations"] = nil

  #   stub_content_store_has_item(content_item["base_path"], content_item.to_json)
  #   visit_with_cachebust(content_item["base_path"])

  #   within find(".worldwide-organisation-header__metadata", match: :first) do
  #     assert_not page.has_content? "Location:"
  #     assert_not page.has_content? "Part of:"
  #   end
  # end

  # test "does not render the translations when there are no translations" do
  #   setup_and_visit_content_item("worldwide_corporate_information_page")

  #   assert_not page.has_text?("English")
  # end

  # test "renders the translations when there are translations" do
  #   setup_and_visit_content_item(
  #     "worldwide_corporate_information_page",
  #     {
  #       "links" => {
  #         "available_translations" =>
  #           [
  #             {
  #               "locale": "en",
  #               "base_path": "/world/organisations/british-embassy-madrid/about/recruitment",
  #             },
  #             {
  #               "locale": "es",
  #               "base_path": "/world/organisations/british-embassy-madrid/about/recruitment.es",
  #             },
  #           ],
  #       },
  #     },
  #   )

  #   assert page.has_text?("English")
  #   assert page.has_link?("Español", href: "/world/organisations/british-embassy-madrid/about/recruitment.es")
  # end
end
