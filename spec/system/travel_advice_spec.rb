RSpec.describe "TravelAdvice" do
  context "index" do
    before do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)
    end

    it "displays the list of countries" do
      visit "/foreign-travel-advice"

      expect(page.status_code).to eq(200)

      within("head", visible: :all) do
        expect(page).to have_selector("title", text: "Foreign travel advice", visible: :all)
        expect(page).to have_selector("link[rel=alternate][type='application/atom+xml'][href='/foreign-travel-advice.atom']", visible: :all)
        expect(page).to have_selector("meta[name=description][content='Latest travel advice by country including safety and security, entry requirements, travel warnings and health']", visible: false)
      end

      expect(page).to have_selector("#wrapper.travel-advice")

      within("#content") do
        within(".gem-c-title") do
          expect(page).to have_content("Foreign travel advice")
        end

        expect(page).to have_selector("#country-filter")
        names = page.all("ul.js-countries-list li a").map(&:text)
        expect(names).to eq(["Afghanistan", "Austria", "Finland", "India", "Malaysia", "S\u00E3o Tom\u00E9 and Principe", "Spain"])

        within(".list#A") do
          expect(page).to have_link("Afghanistan", href: "/foreign-travel-advice/afghanistan")
        end

        within(".list#M") do
          expect(page).to have_link("Malaysia", href: "/foreign-travel-advice/malaysia")
        end

        within(".list#S") do
          expect(page).to have_link("Spain", href: "/foreign-travel-advice/spain")
        end
      end
      group_headers = page.all(".list h2").map(&:text)

      expect(group_headers).to eq(group_headers.sort)
    end

    it "has the correct titles" do
      visit "/foreign-travel-advice"

      expect(page).to have_title("Foreign travel advice")
      expect(page.title).to eq("Foreign travel advice - GOV.UK")
    end

    it "sets the slimmer #wrapper classes" do
      visit "/foreign-travel-advice"

      expect(page.find("#wrapper")["class"]).to include("travel-advice")
    end

    it "displays breadcrumbs" do
      visit "/foreign-travel-advice"

      expect(page).to have_css(".gem-c-contextual-breadcrumbs")
    end

    context "with the javascript driver" do
      before do
        content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
        base_path = content_item.fetch("base_path")
        stub_content_store_has_item(base_path, content_item)
        Capybara.current_driver = Capybara.javascript_driver
      end

      it "loads the page and performs filtering correctly" do
        visit "/foreign-travel-advice"

        expect(page).to have_content("Foreign travel advice")

        page.execute_script("document.body.className = ((document.body.className) ? document.body.className + ' govuk-frontend-supported' : 'govuk-frontend-supported');")

        expect(page).to have_selector("#country-filter")

        within("#country-filter") { fill_in("country", with: "In") }

        within(".countries-wrapper") do
          expect(page).to have_selector("#I li")
          expect(page).to have_selector("#F li")
          expect(page).to have_selector("#S li")
          expect(page).not_to have_selector("#A li")
          expect(page).not_to have_selector("#M li")
        end

        within(".js-country-count") do
          expect(page).to have_selector(".js-filter-count", text: "4")
        end
      end
    end
  end

  context "show" do
    before do
      @content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "full-country")
      @base_path = @content_store_response.fetch("base_path")
      stub_content_store_has_item(@base_path, @content_store_response)
    end

    it "displays the page" do
      visit @base_path

      expect(page.status_code).to eq(200)
    end

    it "displays the title" do
      visit @base_path

      expect(page).to have_title("#{@content_store_response['details']['country']['name']} travel advice")

      within(".gem-c-title") do
        expect(page).to have_content(@content_store_response["details"]["country"]["name"])
      end
    end

    it "displays the email sign-up link" do
      visit @base_path

      expect(page).to have_css("a[href=\"#{@content_store_response['details']['email_signup_link']}\"]", text: "Get email alerts")
    end

    it "displays the navigation" do
      visit @base_path

      parts_size = @content_store_response["details"]["parts"].size

      expect(page).to have_css(".part-navigation-container nav li", count: parts_size)
      expect(page).to have_css(".part-navigation-container nav li", text: @content_store_response["details"]["parts"].first["title"])
      expect(page).not_to have_css(".part-navigation li a", text: @content_store_response["details"]["parts"].first["title"])

      @content_store_response["details"]["parts"][1..parts_size].each do |part|
        expect(page).to have_css(".part-navigation-container nav li a[href*=\"#{part['slug']}\"]", text: part["title"])
      end

      expect(page).to have_css(".govuk-pagination")
      expect(page).to have_css('.govuk-link.govuk-link--no-visited-state[href$="/print"]', text: I18n.t("multi_page.print_entire_guide"))
    end

    it "displays breadcrumbs" do
      visit @base_path

      expect(page).to have_css(".gem-c-contextual-breadcrumbs")
    end

    context "first part" do
      it "displays latest updates" do
        visit @base_path

        expect(page).to have_css("h1", text: @content_store_response["details"]["parts"].first["title"])
        expect(page).to have_text("The main opposition party has called for mass protests against the government in Tirana on 18 February 2017.")

        expect(page).to have_content(I18n.t("formats.travel_advice.still_current_at"))
        expect(page).to have_content(Time.zone.today.strftime("%-d %B %Y"))

        expect(page).to have_content(I18n.t("formats.travel_advice.updated"))
        expect(page).to have_content(Date.parse(@content_store_response["details"]["reviewed_at"]).strftime("%-d %B %Y"))

        within ".gem-c-metadata" do
          expect(page).to have_content(@content_store_response["details"]["change_description"].gsub("Latest update: ", "").strip)
        end
      end

      it "displays the map" do
        visit @base_path

        expect(page).to have_css(".map img[src=\"#{@content_store_response['details']['image']['url']}\"]")
        expect(page).to have_css(".map figcaption a[href=\"#{@content_store_response['details']['document']['url']}\"]", text: "Download a more detailed map (PDF)")
      end
    end

    context "other parts" do
      before do
        @part = @content_store_response.dig("details", "parts").last
      end

      it "only renders one part" do
        visit "#{@base_path}/#{@part['slug']}"

        expect(page).to have_title("#{@part['title']} - #{@content_store_response['title']} - GOV.UK")
        expect(page).to have_css("h1", text: @part["title"])
        expect(page).to have_text("If you’re abroad and you need emergency help from the UK government, contact the nearest British embassy, consulate or high commission")
      end

      it "does not display a map" do
        visit "#{@base_path}/#{@part['slug']}"

        expect(page).not_to have_css(".map")
        expect(page).not_to have_css(".gem-c-metadata")
      end

      it "does not display navigation links for the part" do
        visit "#{@base_path}/#{@part['slug']}"

        expect(page).to have_css(".part-navigation-container nav li", text: @part["title"])
        expect(page).not_to have_css(".part-navigation-container nav li a", text: @part["title"])
      end
    end

    it "includes a discoverable atom feed link" do
      visit @base_path

      expect(page).to have_css("link[type*='atom'][href='#{@base_path}.atom']", visible: false)
    end

    it "does not render with the single page notification button" do
      visit @base_path

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end

    it "has GA4 tracking on the print link" do
      visit @base_path

      expected_ga4_json = {
        event_name: "navigation",
        type: "print page",
        section: "Footer",
        text: "View a printable version of the whole guide",
      }.to_json

      expect(page).to have_css("a[data-ga4-link='#{expected_ga4_json}']")
    end
  end
end
