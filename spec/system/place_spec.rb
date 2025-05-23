require "gds_api/test_helpers/places_manager"

RSpec.describe "Places" do
  include GdsApi::TestHelpers::PlacesManager

  let(:content_item_example) { GovukSchemas::Example.find("place", example_name: "find-regional-passport-office") }

  before do
    @payload = {
      title: "Find a passport interview office",
      base_path: "/passport-interview-office",
      schema_name: "place",
      document_type: "place",
      phase: "beta",
      public_updated_at: "2012-10-02T15:21:03+00:00",
      details: {
        introduction:
          "<p>Enter your postcode to find a passport interview office near you.</p>",
        more_information: "Some more info on passport offices",
        need_to_know: "<ul><li>Proof of identification required</li></ul>",
        place_type: "find-passport-offices",
      },
      external_related_links: [],
    }

    stub_content_store_has_item("/passport-interview-office", @payload)

    @places = [
      {
        "access_notes" =>
          "The London Passport Office is fully accessible to wheelchair users. ",
        "address1" => nil,
        "address2" => "89 Eccleston Square",
        "email" => nil,
        "fax" => nil,
        "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
        "location" => {
          "longitude" => -0.14411606838362725,
          "latitude" => 51.49338734529598,
        },
        "name" => "London IPS Office",
        "phone" => "0800 123 4567",
        "postcode" => "SW1V 1PN",
        "text_phone" => nil,
        "town" => "London",
        "url" => "http://www.example.com/london_ips_office",
      },
      {
        "access_notes" =>
          "The doors are always locked.\n\nAnd they are at the top of large staircases.",
        "address1" => nil,
        "address2" => "Station Way",
        "email" => nil,
        "fax" => nil,
        "general_notes" =>
          "Monday to Saturday 8.00am - 6.00pm.\n\nSunday 1pm - 2pm.",
        "location" => {
          "longitude" => -0.18832238262617113,
          "latitude" => 51.112777245292826,
        },
        "name" => "Crawley IPS Office",
        "phone" => nil,
        "postcode" => "RH10 1HU",
        "text_phone" => nil,
        "town" => "Crawley",
        "url" => nil,
      },
    ]
  end

  context "when visiting the start page" do
    before { visit "/passport-interview-office" }

    it "renders the place page" do
      expect(page.status_code).to eq(200)

      within("head", visible: :all) do
        expect(page).to have_selector("title", text: "Find a passport interview office - GOV.UK", visible: :all)
      end

      within("#content") do
        within(".gem-c-heading h1") do
          expect(page).to have_title("Find a passport interview office")
        end

        expect(page).to have_content("Enter your postcode to find a passport interview office near you.")
        expect(page).to have_field("Enter a postcode")
        expect(page).to have_css("button", text: "Find results near you")
        expect(page).not_to have_content("Please enter a valid full UK postcode.")

        within(".further-information") do
          expect(page).to have_content("Further information")
          within("ul") do
            expect(page).to have_selector("li", text: "Proof of identification required")
          end
        end
      end

      expect(page).to have_selector(".gem-c-phase-banner")
    end

    it "adds GA4 form submit attributes" do
      data_module = page.find("form")["data-module"]
      expected_data_module = "ga4-form-tracker"
      ga4_form_attribute = page.find("form")["data-ga4-form"]
      ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"place\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find a passport interview office\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_form_attribute).to eq(ga4_expected_object)
    end
  end

  context "when page title is not among ones used for button text" do
    before do
      stub_content_store_has_item("/find-regional-passport-office", content_item)
      visit "/find-regional-passport-office"
    end

    context "when page is in English" do
      let(:content_item) { content_item_example }

      it "displays English default button text" do
        expect(page).to have_css("button", text: "Find results near you")
      end
    end

    context "when page is in another language" do
      let(:content_item) { content_item_example.merge({ "locale" => "cy" }) }

      it "displays translated default button text" do
        expect(page).to have_css("button", text: "Darganfod canlyniadau yn agos i chi")
      end
    end
  end

  context "when page title is among ones used for button text" do
    before do
      content_item_example["title"] = "Find a register office"
      content_item_example["base_path"] = "/register-offices"
      stub_content_store_has_item("/register-offices", content_item)
      visit "/register-offices"
    end

    context "when page is in English" do
      let(:content_item) { content_item_example.merge({ "title" => "Find a register office" }) }

      it "displays page title in English as button text" do
        expect(page).to have_css("button", text: "Find a register office")
        expect(page).not_to have_css("button", text: "Find results near you")
      end
    end

    context "when page is in another language" do
      let(:content_item) { content_item_example.merge({ "title" => "Darganfod swyddfa gofrestru", "locale" => "cy" }) }

      it "displays page title in another language as button text" do
        expect(page).to have_css("button", text: "Darganfod swyddfa gofrestru")
        expect(page).not_to have_css("button", text: "Darganfod canlyniadau yn agos i chi")
      end
    end
  end

  context "with a valid postcode" do
    before do
      stub_places_manager_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::PLACES_MANAGER_QUERY_LIMIT, nil)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "SW1A 1AA")
      click_on("Find results near you")
    end

    it "redirects to same page and not put postcode as URL query parameter" do
      expect(page).to have_current_path("/passport-interview-office", ignore_query: true)
    end

    it "does not display an error message" do
      expect(page).not_to have_content("Please enter a valid full UK postcode.")
    end

    it "does not show the 'no results' message" do
      expect(page).not_to have_content("We couldn't find any results for this postcode.")
    end

    it "displays places near to the requested location" do
      names = page.all("#options li .adr h3.fn").map(&:text)

      expect(names).to eq(["London IPS Office", "Crawley IPS Office"])

      within("#options > li:first-child") do
        expect(page).to have_content("89 Eccleston Square")
        expect(page).to have_content("London")
        expect(page).to have_content("SW1V 1PN")
        expect(page).to have_link("http://www.example.com/london_ips_office", href: "http://www.example.com/london_ips_office")
        expect(page).to have_content("Telephone: 0800 123 4567")
        expect(page).to have_content("Monday to Saturday 8.00am - 6.00pm.")
        expect(page).to have_content("The London Passport Office is fully accessible to wheelchair users.")
      end
    end

    it "formats general notes and access notes" do
      within("#options > li:nth-child(2)") do
        expect(page).to have_content("Station Way")
        expect(page).to have_selector("p", text: "Monday to Saturday 8.00am - 6.00pm.")
        expect(page).to have_selector("p", text: "Sunday 1pm - 2pm.")
        expect(page).to have_selector("p", text: "The doors are always locked.")
        expect(page).to have_selector("p", text: "And they are at the top of large staircases.")
      end
    end

    it "adds GA4 form_complete attributes" do
      data_module = page.find(".places-results")["data-module"]
      expected_data_module = "ga4-auto-tracker ga4-link-tracker"
      ga4_auto_attribute = page.find(".places-results")["data-ga4-auto"]
      ga4_expected_object = "{\"event_name\":\"form_complete\",\"action\":\"complete\",\"type\":\"place\",\"text\":\"Results near [postcode]\",\"tool_name\":\"Find a passport interview office\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_auto_attribute).to eq(ga4_expected_object)
    end

    it "adds GA4 information click attributes" do
      data_module = page.find(".places-results")["data-module"]
      expected_data_module = "ga4-auto-tracker ga4-link-tracker"

      expect(page).to have_selector("[data-ga4-set-indexes]")
      expect(page).to have_selector("[data-ga4-track-links-only]")

      ga4_auto_attribute = page.find(".places-results")["data-ga4-link"]
      ga4_expected_object = "{\"event_name\":\"information_click\",\"action\":\"information click\",\"type\":\"place\",\"tool_name\":\"Find a passport interview office\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_auto_attribute).to eq(ga4_expected_object)
    end
  end

  context "with a valid postcode which has no nearby places" do
    before do
      @places = []
      stub_places_manager_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::PLACES_MANAGER_QUERY_LIMIT, nil)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "SW1A 1AA")
      click_on("Find results near you")
    end

    it "does not error on a bad postcode" do
      expect(page).not_to have_content("Please enter a valid full UK postcode.")
    end

    it "informs the user on the lack of results" do
      expect(page).to have_content("We couldn't find any results for this postcode.")
    end
  end

  context "with an empty postcode" do
    before do
      visit "/passport-interview-office"
      click_on("Find results near you")
    end

    it "displays error message" do
      expect(page).to have_content("This isn't a valid postcode")
    end

    it "includes GA4 form error attributes" do
      data_module = page.find("#results")["data-module"]
      expected_data_module = "ga4-auto-tracker govuk-error-summary"
      ga4_error_attribute = page.find("#results")["data-ga4-auto"]
      ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"place\",\"text\":\"This isn't a valid postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find a passport interview office\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_error_attribute).to eq(ga4_expected_object)
    end

    it "displays the postcode form" do
      within(".location-form") do
        expect(page).to have_field("Enter a postcode")
        expect(page).to have_field("postcode")
        expect(page).to have_css("button", text: "Find")
      end
    end
  end

  context "with an invalid postcode" do
    before do
      query_hash = { "postcode" => "BAD POSTCODE", "limit" => Frontend::PLACES_MANAGER_QUERY_LIMIT }
      return_data = { "error" => "invalidPostcodeError" }
      stub_places_manager_places_request("find-passport-offices", query_hash, return_data, 400)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "BAD POSTCODE")
      click_on("Find results near you")
    end

    it "displays error message" do
      expect(page).to have_content("This isn't a valid postcode")
    end

    it "does not show the 'no results' message" do
      expect(page).not_to have_content("We couldn't find any results for this postcode.")
    end

    it "displays the postcode form" do
      within(".location-form") do
        expect(page).to have_field("Enter a postcode")
        expect(page).to have_field("postcode", with: "BAD POSTCODE")
        expect(page).to have_css("button", text: "Find results near you")
      end
    end
  end

  context "with a valid postcode but with no locations returned" do
    before do
      query_hash = { "postcode" => "JE4 5TP", "limit" => Frontend::PLACES_MANAGER_QUERY_LIMIT }
      return_data = { "error" => "validPostcodeNoLocation" }
      stub_places_manager_places_request("find-passport-offices", query_hash, return_data, 400)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "JE4 5TP")
      click_on("Find results near you")
    end

    it "displays the 'no locations found' message" do
      expect(page).to have_content("We couldn't find any results for this postcode.")
    end
  end

  context "when previously a format with parts" do
    it "reroutes to the base slug if requested with part route" do
      visit "/passport-interview-office/old-part-route"

      expect(page).to have_current_path("/passport-interview-office", ignore_query: true)
    end
  end

  context "with a postcode which covers multiple authorities (and a local_authority place)" do
    before do
      addresses = [
        { "address" => "House 1", "local_authority_slug" => "achester" },
        { "address" => "House 2", "local_authority_slug" => "beechester" },
        { "address" => "House 3", "local_authority_slug" => "ceechester" },
      ]
      stub_places_manager_has_multiple_authorities_for_postcode(addresses, "find-passport-offices", "CH25 9BJ", Frontend::PLACES_MANAGER_QUERY_LIMIT)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "CH25 9BJ")
      click_on("Find results near you")
    end

    it "displays the address chooser" do
      expect(page).to have_content("House 1")
    end
  end

  context "when places manager returns an error" do
    before do
      query_hash = { "postcode" => "JE4 5TP", "limit" => Frontend::PLACES_MANAGER_QUERY_LIMIT }
      stub_places_manager_places_request("find-passport-offices", query_hash, {}, 500)
      visit "/passport-interview-office"
      fill_in("Enter a postcode", with: "JE4 5TP")
      click_on("Find results near you")
    end

    it "reraises as a 503" do
      expect(page.status_code).to eq(503)
    end
  end
end
