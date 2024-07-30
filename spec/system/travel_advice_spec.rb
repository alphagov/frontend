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

      expect(page.find("#wrapper")["class"]).to eq("travel-advice")
    end
  end

  context "index with the javascript driver" do
    before do
      content_item = GovukSchemas::Example.find("travel_advice_index", example_name: "index")
      base_path = content_item.fetch("base_path")
      stub_content_store_has_item(base_path, content_item)
      Capybara.current_driver = Capybara.javascript_driver
    end

    it "loads the page and performs filtering correctly" do
      visit "/foreign-travel-advice"

      expect(page).to have_content("Foreign travel advice")

      page.execute_script("document.body.className = ((document.body.className) ? document.body.className + ' js-enabled' : 'js-enabled');")

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
