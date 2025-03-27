RSpec.describe "CorporateInformationPage" do
  context "when visiting a Corporate Information page" do
    let(:content_store_response) { GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page_with_groups") }

    before do
      content_store_has_example_item("/government/organisations/department-of-health/about", schema: :corporate_information_page, example: :corporate_information_page_with_groups)
      visit "/government/organisations/department-of-health/about"
    end

    it "displays the title" do
      within(".gem-c-heading") do
        expect(page).to have_title("About us - Department of Health and Social Care - GOV.UK")
        expect(page).to have_css("h1", text: content_store_response["title"])
      end
    end

    it "displays the description" do
      expect(page).to have_css("p", text: content_store_response["description"])
    end

    it "displays the organisation logo" do
      within(".gem-c-organisation-logo") do
        expect(page).to have_css(".gem-c-organisation-logo__name", text: "Departmentof Health")
      end
    end

    it "displays the contents list heading links" do
      within(".gem-c-contents-list-with-body") do
        expect(page).to have_css("h2", text: "Contents")
        expect(page).to have_link("Our responsibilities", href: "#our-responsibilities")
      end
    end

    context "when corporate information is available" do
      it "displays H2 link in contents list" do
        within(".gem-c-contents-list-with-body") do
          expect(page).to have_link("Corporate information", href: "#corporate-information")
        end
      end

      it "displays H2 in content" do
        within(".gem-c-govspeak") do
          expect(page).to have_css("h2", text: "Corporate information", id: "corporate-information")
        end
      end

      context "when corporate information groups are available" do
        it "displays the headings" do
          within(".gem-c-govspeak") do
            expect(page).to have_css("h3", text: "Access our information", id: "access-our-information")
            expect(page).to have_css("h3", text: "Jobs and contracts", id: "jobs-and-contracts")
          end
        end

        it "displays group links" do
          within(".gem-c-govspeak") do
            expect(page).to have_link("Our organisation chart", href: "https://data.gov.uk/dataset/04427362-663e-49e0-9103-8bc01dcaa2c7/organogram-of-staff-roles-and-salaries")
            expect(page).to have_link("Procurement at DHSC", href: "/government/organisations/department-of-health-and-social-care/about/procurement")
          end
        end
      end

      it "displays further information" do
        within(".gem-c-govspeak") do
          expect(page).to have_css("p", text: "Our Personal information charter explains how we treat your personal information.")
        end
      end
    end

    it "displays the back to top link" do
      within(".gem-c-contents-list-with-body__link-container") do
        expect(page).to have_link("Contents", href: "#contents")
      end
    end
  end

  context "when visiting a Corporate Information page that does not have additional corporate information" do
    before do
      content_store_has_example_item("/government/organisations/department-of-health/about/our-governance", schema: :corporate_information_page, example: :corporate_information_page_without_description)
      visit "/government/organisations/department-of-health/about/our-governance"
    end

    it "does not displays H2 link in contents list" do
      within(".gem-c-contents-list-with-body") do
        expect(page).not_to have_link("Corporate information", href: "#corporate-information")
      end
    end

    it "does not displays H2 in content" do
      within(".gem-c-govspeak") do
        expect(page).not_to have_css("h2", text: "Corporate information", id: "corporate-information")
      end
    end
  end

  context "when visiting a withdrawn Corporate Information page" do
    before do
      content_store_has_example_item("/government/organisations/department-for-work-pensions/about/welsh-language-scheme", schema: :corporate_information_page, example: "best-practice-welsh-language-scheme-withdrawn")
      visit "/government/organisations/department-for-work-pensions/about/welsh-language-scheme"
    end

    it "displays the withdrawn notice" do
      within(".govuk-notification-banner__content") do
        expect(page).to have_css("h2.gem-c-notice__title", text: "This information page was withdrawn on 10 February 2018")

        expect(page).to have_css("p", text: "This information has been withdrawn as it is out of date.")
      end
    end
  end

  context "when visiting a Corporate Information page which is translatable" do
    before do
      content_store_has_example_item("/government/organisations/department-for-work-pensions/about/welsh-language-scheme", schema: :corporate_information_page, example: "best-practice-welsh-language-scheme-withdrawn")
      visit "/government/organisations/department-for-work-pensions/about/welsh-language-scheme"
    end

    it "displays the available translations" do
      within(".gem-c-translation-nav") do
        expect(page).to have_css(".gem-c-translation-nav__list-item", text: "English")
        expect(page).to have_link("Cymraeg", href: "/government/organisations/department-for-work-pensions/about/welsh-language-scheme.cy")
      end
    end
  end
end
