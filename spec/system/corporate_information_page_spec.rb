RSpec.describe "CorporateInformationPage" do
  context "when visiting a Corporate Information page" do
    before do
      @content_store_response = GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page")
      content_store_has_example_item("/government/organisations/department-of-health/about", schema: :corporate_information_page, example: :corporate_information_page)
      content_store_has_example_item("/government/organisations/department-for-work-pensions/about/welsh-language-scheme", schema: :corporate_information_page, example: "best-practice-welsh-language-scheme-withdrawn")
      visit "/government/organisations/department-of-health/about"
    end

    it "displays the title" do
      within(".gem-c-heading") do
        expect(page).to have_title("About us - Department of Health - GOV.UK")
        expect(page).to have_css("h1", text: @content_store_response["title"])
      end
    end

    it "displays the description" do
      expect(page).to have_css("p", text: @content_store_response["description"])
    end

    it "displays the organisation logo" do
      within(".gem-c-organisation-logo") do
        expect(page).to have_css(".gem-c-organisation-logo__name", text: "Departmentof Health")
      end
    end

    it "displays the brand colour if available" do
      expect(page).to have_css(".department-of-health-brand-colour")
    end

    it "displays the contents list headings" do
      within(".app-c-contents-list-with-body") do
        expect(page).to have_css("h2", text: "Contents")
        expect(page).to have_link("Our responsibilities", href: "#our-responsibilities")
      end
    end

    it "displays further information" do
      within(".gem-c-govspeak") do
        expect(page).to have_css("p", text: "Our Personal information charter explains how we treat your personal information.")
      end
    end

    it "displays the back to top link" do
      within(".app-c-contents-list-with-body__link-container") do
        expect(page).to have_link("Contents", href: "#contents")
      end
    end
  end

  context "when visiting a withdrawn Corporate Information page" do
    before do
      content_store_has_example_item("/government/organisations/department-for-work-pensions/about/welsh-language-scheme", schema: :corporate_information_page, example: "best-practice-welsh-language-scheme-withdrawn")
    end

    it "displays the withdrawn notice" do
      visit "/government/organisations/department-for-work-pensions/about/welsh-language-scheme"

      within(".govuk-notification-banner__content") do
        expect(page).to have_css("h2.gem-c-notice__title", text: "This information page was withdrawn on 10 February 2018")

        expect(page).to have_css("p", text: "This information has been withdrawn as it is out of date.")
      end
    end
  end

  context "when visiting a Corporate Information page which is translatable" do
    before do
      content_store_has_example_item("/government/organisations/department-for-work-pensions/about/welsh-language-scheme", schema: :corporate_information_page, example: "best-practice-welsh-language-scheme-withdrawn")
    end

    it "displays the available translations" do
      visit "/government/organisations/department-for-work-pensions/about/welsh-language-scheme"

      within(".gem-c-translation-nav") do
        expect(page).to have_css(".gem-c-translation-nav__list-item", text: "English")
        expect(page).to have_link("Cymraeg", href: "/government/organisations/department-for-work-pensions/about/welsh-language-scheme.cy")
      end
    end
  end
end
