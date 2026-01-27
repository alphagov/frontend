RSpec.describe "Worldwide office page" do
  describe "GET /<document_type>/<slug>" do
    let(:content_store_response) { GovukSchemas::Example.find("worldwide_office", example_name: "worldwide_office") }
    let(:base_path) { content_store_response.fetch("base_path") }

    def setup_and_visit_page
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    before do
      setup_and_visit_page
    end

    it "displays the page" do
      expect(page.status_code).to eq(200)
    end

    it "includes the title of the organisation" do
      expect(page.title).to eq("British Embassy Manila - GOV.UK")
    end

    it "includes the title of the office contact" do
      expect(page).to have_css("h2", text: "Consular section")
    end

    it "omits breadcrumbs" do
      expect(page).not_to have_css(".govuk-breadcrumbs")
    end

    it "includes access details and contents" do
      expect(page).to have_text("Contents")

      expect(page).to have_css(".gem-c-contents-list"), "Failed to find an element with a class of contents-list"

      contents = [
        { text: "Disabled access", id: "disabled-access" },
        { text: "Public Holidays for 2023", id: "public-holidays-for-2023" },
      ]

      within ".gem-c-contents-list" do
        contents.each do |heading|
          selector = "a[href=\"##{heading[:id]}\"]"
          text = heading.fetch(:text)
          expect(page).to have_css(selector), "Failed to find an element matching: #{selector}"
          expect(page).to have_css(selector, text:), "Failed to find an element matching #{selector} with text: #{text}"
        end
      end

      expect(page).to have_text("The British Embassy Manila is keen to ensure that our building and services are fully accessible to disabled members of the public.")
    end

    it "omits access details and contents when they are not included in the content item" do
      content_store_response["details"]["headers"] = nil
      setup_and_visit_page

      expect(page).to have_selector("h2", text: "Consular section")
      expect(page).not_to have_text("Contents")
    end

    it "includes the address" do
      within "address" do
        expect(page).to have_text("British Embassy Manila")
        expect(page).to have_text("120 Upper McKinley Road, McKinley Hill")
        expect(page).to have_text("Taguig City")
        expect(page).to have_text("Manila")
        expect(page).to have_text("1634")
        expect(page).to have_text("Philippines")
      end
    end

    it "includes the contact details" do
      expect(page).to have_text("Email")
      expect(page).to have_link("ukinthephilippines@fco.gov.uk")
      expect(page).to have_text("Contact form")
      expect(page).to have_link("http://www.gov.uk/contact-consulate-manila", href: "http://www.gov.uk/contact-consulate-manila")

      expect(page).to have_text("Telephone")
      expect(page).to have_text("+63 (02) 8 858 2200 / +44 20 7136 6857 (line open 24/7)")
    end

    it "includes the contact comments" do
      expect(page).to have_text("24/7 consular support is available by telephone for all routine enquiries and emergencies.")
    end

    it "includes the logo and formatted name of the worldwide organisation as a link" do
      expect(page).to have_css(".gem-c-organisation-logo")
      expect(page).to have_css("h1", text: "British EmbassyManila")
      expect(page).to have_link("British EmbassyManila", href: "/world/organisations/british-embassy-manila")
    end

    it "includes the world locations and sponsoring organisations" do
      within(".worldwide-organisation-header__metadata") do
        expect(page).to have_text("News:")
        expect(page).to have_link("Philippines", href: "/world/philippines/news")
        expect(page).to have_link("Palau", href: "/world/palau/news")

        expect(page).to have_text("Part of:")
        expect(page).to have_link("Foreign, Commonwealth & Development Office", href: "/government/organisations/foreign-commonwealth-development-office")
      end
    end

    it "omits the world locations and sponsoring organisations when they are absent" do
      content_store_response["links"]["worldwide_organisation"][0]["links"]["sponsoring_organisations"] = nil
      content_store_response["links"]["worldwide_organisation"][0]["links"]["world_locations"] = nil
      setup_and_visit_page

      within(".worldwide-organisation-header__metadata") do
        expect(page.has_content?("Location:")).to be(false)
        expect(page.has_content?("Part of:")).to be(false)
      end
    end
  end
end
