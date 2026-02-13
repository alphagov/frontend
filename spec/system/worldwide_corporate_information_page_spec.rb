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

    it "omits the world locations and sponsoring organisations when they are absent" do
      content_store_response["links"]["worldwide_organisation"][0]["links"]["sponsoring_organisations"] = nil
      content_store_response["links"]["worldwide_organisation"][0]["links"]["world_locations"] = nil

      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      within find(".worldwide-organisation-header__metadata", match: :first) do
        expect(page).not_to have_text("Location:")
        expect(page).not_to have_text("Part of:")
      end
    end

    it "does not render the translations when there are no translations" do
      expect(page).not_to have_text("English")
    end

    it "renders the translations when there are translations" do
      content_store_response["links"]["available_translations"] =
        [
          {
            "locale": "en",
            "base_path": "/world/organisations/british-embassy-madrid/about/recruitment",
          },
          {
            "locale": "es",
            "base_path": "/world/organisations/british-embassy-madrid/about/recruitment.es",
          },
        ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).to have_text("English")
      expect(page).to have_link("Español", href: "/world/organisations/british-embassy-madrid/about/recruitment.es")
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
end
