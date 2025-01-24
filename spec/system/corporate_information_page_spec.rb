RSpec.describe "CorporateInformationPage" do
  context "when visiting a Case Study page" do
    before do
      @content_store_response = GovukSchemas::Example.find("corporate_information_page", example_name: "corporate_information_page")
      content_store_has_example_item("/government/organisations/department-of-health/about", schema: :corporate_information_page, example: :corporate_information_page)
      visit "/government/organisations/department-of-health/about"
    end

    it "displays the title" do
      within(".gem-c-title") do
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
end
