RSpec.describe "Worldwide organisation page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("worldwide_organisation", example_name: "worldwide_organisation") }
    let(:base_path) { content_store_response.fetch("base_path") }

    def setup_and_visit_page
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    before do
      setup_and_visit_page
    end

    it "renders basic worldwide organisation page" do
      expect(page).to have_css("h1", text: "UK Embassy in Country")
      expect(page).to have_css(".gem-c-organisation-logo__name")
      expect(page).to have_text(content_store_response["description"])
    end

    it "omits breadcrumbs" do
      expect(page).not_to have_css(".govuk-breadcrumbs")
    end

    it "renders rtl text direction when the locale is a rtl language" do
      content_store_response["locale"] = "ar"
      setup_and_visit_page
      expect(page).to have_css(".govuk-main-wrapper.direction-rtl"), "has .direction-rtl class on .govuk-main-wrapper element"
    end

    it "renders the body content" do
      expect(page).to have_css("#about-us")
      expect(page).to have_text("Find out more on our UK and India")
    end

    it "renders the person in the primary role" do
      expect(page).to have_link("Karen Pierce DCMG", href: "/government/people/karen-pierce")
      expect(page).to have_css("img[src=\"https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/583/s216_UKMissionGeneva__HMA_Karen_Pierce_-_uploaded.jpg\"]")
    end

    it "renders people in secondary and office roles" do
      expect(page).to have_link("Justin Sosne", href: "/government/people/justin-sosne")
      expect(page).to have_link("Rachel Galloway", href: "/government/people/rachel-galloway")
    end

    it "doesn't render the people section if there are no appointed people" do
      content_store_response["links"]["primary_role_person"] = nil
      content_store_response["links"]["secondary_role_person"] = nil
      content_store_response["links"]["office_staff"] = nil
      setup_and_visit_page
      expect(page).not_to have_text("Our people")
    end

    it "renders the navigational corporate information pages" do
      expect(page).to have_link("Complaints procedure", href: "/world/organisations/british-deputy-high-commission-hyderabad/about/complaints-procedure")
    end

    it "renders the secondary corporate information pages" do
      expect(page).to have_text("Our Personal information charter explains how we treat your personal information.")
      expect(page).to have_link("Personal information charter", href: "/world/organisations/british-deputy-high-commission-hyderabad/about/personal-information-charter")
    end

    it "doesn't render the corporate pages section if there are no pages to show" do
      content_store_response["links"]["corporate_information_pages"] = nil
      content_store_response["details"]["secondary_corporate_information_pages"] = ""
      setup_and_visit_page

      expect(page).not_to have_text("Corporate information")
    end

    it "does not render the translations when there are no translations" do
      expect(page).not_to have_text("English")
    end

    it "renders the translations when there are translations" do
      content_store_response["links"]["available_translations"] = [
        {
          "locale": "en",
          "base_path": "/world/uk-embassy-in-country",
        },
        {
          "locale": "de",
          "base_path": "/world/uk-embassy-in-country.de",
        },
      ]
      setup_and_visit_page

      expect(page).to have_text("English")
      expect(page).to have_link("Deutsch", href: "/world/uk-embassy-in-country.de")
    end

    it "renders the main office contact with a link to the office page" do
      within("#contact-us") do
        expect(page).to have_text("Contact us")
        expect(page).to have_content("British Embassy Madrid")
        expect(page).to have_link(I18n.t("contact.access_and_opening_times"), href: "/world/organisations/british-embassy-madrid/office/british-embassy")
      end
    end

    it "renders the main office contact without a link to the office page when the office has no access details" do
      content_store_response["details"]["mail_office_parts"] =
        [
          {
            "access_and_opening_times": nil,
            "contact_content_id": "410c4c3b-5c1c-4617-b603-4356bedcc85e",
            "slug": "office/british-embassy",
            "title": "British Embassy",
            "type": "Embassy",
          },
        ]

      within("#contact-us") do
        expect(page).to have_text("Contact us")
        expect(page).to have_content("Torre Emperador Castellana")
        expect(page).not_to have_link(I18n.t("contact.access_and_opening_times"), href: "/world/uk-embassy-in-country/office/british-embassy")
      end
    end

    it "renders the home page offices with a link to the office page" do
      within("#contact-us") do
        expect(page).to have_content("Department for Business and Trade Dusseldorf")
        expect(page).to have_link(I18n.t("contact.access_and_opening_times"), href: "/world/organisations/department-for-business-and-trade-germany/office/uk-trade-investment-duesseldorf")
      end
    end

    it "renders the home page offices without a link to the office page when the office has no access details" do
      content_store_response["details"]["home_page_office_parts"] = [
        {
          "access_and_opening_times": nil,
          "contact_content_id": "53df7197-901c-48fc-b9b4-ed649903f1f0",
          "slug": "office/uk-trade-investment-duesseldorf",
          "title": "Department for Business and Trade Dusseldorf",
          "type": "Department for Business and Trade Office",
        },
      ]

      within("#contact-us") do
        expect(page).to have_content("Department for Business and Trade Dusseldorf")
        expect(page).not_to have_link(I18n.t("contact.access_and_opening_times"), href: "/world/uk-embassy-in-country/office/uk-trade-investment-duesseldorf")
      end
    end

    it "does not render the contacts section if there is no main office" do
      content_store_response["links"]["main_office"] = nil
      setup_and_visit_page
      expect(page).not_to have_text("Contact us")
    end

    it "includes the world locations and sponsoring organisations" do
      within find(".worldwide-organisation-header__metadata", match: :first) do
        expect(page).to have_content("News:")
        expect(page).to have_link("India with translation and the UK", href: "/world/india/news")
        expect(page).to have_link("Another location with translation and the UK", href: "/world/another-location/news")

        expect(page).to have_content("Part of:")
        expect(page).to have_link("Foreign, Commonwealth & Development Office", href: "/government/organisations/foreign-commonwealth-development-office")
      end
    end

    it "omits the world locations and sponsoring organisations when they are absent" do
      content_store_response["links"]["sponsoring_organisations"] = nil
      content_store_response["links"]["world_locations"] = nil

      setup_and_visit_page

      within find(".worldwide-organisation-header__metadata", match: :first) do
        expect(page).not_to have_content("Location:")
        expect(page).not_to have_content("Part of:")
      end
    end
  end
end
