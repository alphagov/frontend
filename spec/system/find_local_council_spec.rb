require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

RSpec.describe "FindLocalCouncil" do
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  before { content_store_has_random_item(base_path: "/find-local-council") }

  context "when visiting the start page" do
    before do
      visit "/find-local-council"
    end

    it "shows Find Local Council start page" do
      expect(page).to have_content("Find your local council")
      expect(page).to have_content("Find the website for your local council.")
      expect(page).to have_field("postcode")
    end

    it "adds GA4 attributes for form submit events" do
      data_module = page.find("form")["data-module"]
      expected_data_module = "ga4-form-tracker"
      ga4_form_attribute = page.find("form")["data-ga4-form"]
      form_type = JSON.parse(ga4_form_attribute)
      ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"#{form_type['type']}\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find your local council\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_form_attribute).to eq(ga4_expected_object)
    end

    it "adds the description as meta tag for SEO purposes" do
      description = page.find("meta[name=\"description\"]", visible: :hidden)["content"]

      expect(description).to eq("Find your local authority in England, Wales, Scotland and Northern Ireland")
    end

    it "has the correct titles" do
      expect(page).to have_title("Find your local council")
      expect(page.title).to eq("Find your local council - GOV.UK")
    end
  end

  context "when entering a postcode in the search form" do
    context "with a successful postcode lookup" do
      context "and with a unitary local authority" do
        before do
          configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
          visit "/find-local-council"
          fill_in("postcode", with: "SW1A 1AA")
          click_on("Find")
        end

        it "redirects to the authority slug" do
          expect(page).to have_current_path("/find-local-council/westminster", ignore_query: true)
        end

        it "shows the local authority result" do
          expect(page).to have_content("Your local authority is")
          within(".unitary-result") do
            expect(page).to have_content("Westminster")
            expect(page).to have_link("Go to Westminster website", href: "http://westminster.example.com", exact: true)
          end
        end

        it "includes the search for another postcode link" do
          expect(page).to have_link("Search for a different postcode", href: "/find-local-council", exact: true)
        end

        it "includes the search result text in the page title" do
          expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
        end

        it "adds GA4 attributes for exit link tracking" do
          element = page.find(".gem-c-button")
          data_module = element["data-module"]
          expected_data_module = "ga4-link-tracker"
          ga4_link_attribute = element["data-ga4-link"]
          form_type = JSON.parse(ga4_link_attribute)
          ga4_expected_object = "{\"event_name\":\"information_click\",\"action\":\"information click\",\"type\":\"#{form_type['type']}\",\"index_link\":1,\"index_total\":1,\"tool_name\":\"Find your local council\"}"

          expect(data_module).to include(expected_data_module)
          expect(ga4_link_attribute).to eq(ga4_expected_object)
        end

        it "adds GA4 attributes" do
          element = page.find(".local-authority-results")
          data_module = element["data-module"]
          expected_data_module = "ga4-auto-tracker"
          ga4_auto_attribute = element["data-ga4-auto"]
          form_type = JSON.parse(ga4_auto_attribute)
          ga4_expected_object = "{\"event_name\":\"form_complete\",\"action\":\"complete\",\"type\":\"#{form_type['type']}\",\"text\":\"Westminster\",\"tool_name\":\"Find your local council\"}"

          expect(data_module).to include(expected_data_module)
          expect(ga4_auto_attribute).to eq(ga4_expected_object)
        end
      end

      context "and with a district local authority" do
        before do
          stub_locations_api_has_location("HP20 1UG", [{ "latitude" => 51.5010096, "longitude" => -0.141587, "local_custodian_code" => 440 }])
          stub_local_links_manager_has_a_district_and_county_local_authority("aylesbury", "buckinghamshire", local_custodian_code: 440)
          visit "/find-local-council"
          fill_in("postcode", with: "HP20 1UG")
          click_on("Find")
        end

        it "redirects to the district authority slug" do
          expect(page).to have_current_path("/find-local-council/aylesbury", ignore_query: true)
        end

        it "includes the search result text in the page title" do
          expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
        end

        it "shows the local authority results for both district and county" do
          expect(page).to have_content("Services in your area are provided by two local authorities")
          expect(page).to have_selector(".county-result")
          expect(page).to have_selector(".district-result")
          within(".county-result") do
            expect(page).to have_content("Buckinghamshire")
            expect(page).to have_content("County councils are responsible for services like:")
            expect(page).to have_link("Go to Buckinghamshire website", href: "http://buckinghamshire.example.com")
          end

          within(".district-result") do
            expect(page).to have_content("Aylesbury")
            expect(page).to have_content("District councils are responsible for services like:")
            expect(page).to have_link("Go to Aylesbury website", href: "http://aylesbury.example.com", exact: true)
          end
        end

        it "adds GA4 attributes for exit link tracking" do
          element = page.find(".local-authority-results")
          links = element.all("a")
          expected_data_module = "ga4-link-tracker"
          links.each_with_index do |link, index|
            data_module = link["data-module"]
            expect(data_module).to include(expected_data_module)
            ga4_link_attribute = link["data-ga4-link"]
            link_type = JSON.parse(ga4_link_attribute)
            ga4_expected_object = "{\"event_name\":\"information_click\",\"action\":\"information click\",\"type\":\"#{link_type['type']}\",\"index_link\":#{index + 1},\"index_total\":2,\"tool_name\":\"Find your local council\"}"
            expect(ga4_link_attribute).to eq(ga4_expected_object)
          end
        end

        it "adds GA4 attributes" do
          element = page.find(".local-authority-results")
          data_module = element["data-module"]
          expected_data_module = "ga4-auto-tracker"
          ga4_auto_attribute = element["data-ga4-auto"]
          form_type = JSON.parse(ga4_auto_attribute)
          ga4_expected_object = "{\"event_name\":\"form_complete\",\"action\":\"complete\",\"type\":\"#{form_type['type']}\",\"text\":\"Buckinghamshire,Aylesbury\",\"tool_name\":\"Find your local council\"}"
          expect(data_module).to include(expected_data_module)
          expect(ga4_auto_attribute).to eq(ga4_expected_object)
        end
      end

      # This tests the rare but possible case where a 2-tier hierarchy has a district
      # and a unitary (rather than district and council), which can happen during merge periods
      # where it is useful for a short period of time to mark a county as a unitary if it is
      # becoming one. See find_local_council_controller#result for more explanation
      context "and for a district local authority with a unitary instead of county upper tier" do
        before do
          stub_locations_api_has_location("HP20 1UG", [{ "latitude" => 51.5010096, "longitude" => -0.141587, "local_custodian_code" => 440 }])
          stub_local_links_manager_has_a_district_and_unitary_local_authority("aylesbury", "buckinghamshire", local_custodian_code: 440)
          visit "/find-local-council"
          fill_in("postcode", with: "HP20 1UG")
          click_on("Find")
        end

        it "redirects to the district authority slug" do
          expect(page).to have_current_path("/find-local-council/aylesbury", ignore_query: true)
        end

        it "includes the search result text in the page title" do
          expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
        end

        it "shows the local authority results for both district and unitary" do
          expect(page).to have_content("Services in your area are provided by two local authorities")
          expect(page).to have_selector(".county-result")
          expect(page).to have_selector(".district-result")
          within(".county-result") do
            expect(page).to have_content("Buckinghamshire")
            expect(page).to have_content("County councils are responsible for services like:")
            expect(page).to have_link("Go to Buckinghamshire website", href: "http://buckinghamshire.example.com")
          end
          within(".district-result") do
            expect(page).to have_content("Aylesbury")
            expect(page).to have_content("District councils are responsible for services like:")
            expect(page).to have_link("Go to Aylesbury website", href: "http://aylesbury.example.com", exact: true)
          end
        end
      end

      context "when finding a local council without homepage" do
        before do
          stub_locations_api_has_location("SW1A 1AA", [{ "latitude" => 51.5010096, "longitude" => -0.141587, "local_custodian_code" => 5990 }])
          stub_local_links_manager_has_a_local_authority_without_homepage("westminster", local_custodian_code: 5990)
          visit "/find-local-council"
          fill_in("postcode", with: "SW1A 1AA")
          click_on("Find")
        end

        it "shows advisory message that we have no URL" do
          expect(page).to have_content("We don't have a link for their website.")
        end
      end
    end

    context "with an unsuccessful postcode lookup" do
      context "with invalid postcode" do
        before do
          stub_locations_api_does_not_have_a_bad_postcode("NO POSTCODE")
          visit "/find-local-council"
          fill_in("postcode", with: "NO POSTCODE")
          click_on("Find")
        end

        it "remains on the find your local council page" do
          expect(page).to have_current_path("/find-local-council", ignore_query: true)
          expect(page).to have_content("Find your local council")
          expect(page).to have_content("Find the website for your local council.")
        end

        it "adds \"Error:\" to the beginning of the page title" do
          expect(page).to have_selector("title", text: "Error: Find your local council - GOV.UK", visible: :hidden)
        end

        it "shows an error message" do
          expect(page).to have_content("This isn't a valid postcode")
        end

        it "re-populates the invalid input" do
          expect(page).to have_field("postcode", with: "NO POSTCODE")
        end

        it "includes GA4 attributes" do
          page_error = page.find("#error")
          data_module = page_error["data-module"]
          expected_data_module = "ga4-auto-tracker"
          ga4_error_attribute = page_error["data-ga4-auto"]
          error_type = JSON.parse(ga4_error_attribute)
          ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"#{error_type['type']}\",\"text\":\"This isn't a valid postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find your local council\"}"
          expect(data_module).to include(expected_data_module)
          expect(ga4_error_attribute).to eq(ga4_expected_object)
        end
      end

      context "with blank postcode" do
        before do
          visit "/find-local-council"
          fill_in("postcode", with: "")
          click_on("Find")
        end

        it "remains on the find your local council page" do
          expect(page).to have_current_path("/find-local-council", ignore_query: true)
          expect(page).to have_content("Find your local council")
          expect(page).to have_content("Find the website for your local council.")
        end

        it "adds \"Error:\" to the beginning of the page title" do
          expect(page).to have_selector("title", text: "Error: Find your local council - GOV.UK", visible: :hidden)
        end

        it "shows an error message" do
          expect(page).to have_content("This isn't a valid postcode")
        end
      end

      context "when multiple authorities (5 or less) are found" do
        before do
          stub_locations_api_has_location(
            "CH25 9BJ",
            [
              { "address" => "House 1", "local_custodian_code" => "1" },
              { "address" => "House 2", "local_custodian_code" => "2" },
              { "address" => "House 3", "local_custodian_code" => "3" },
            ],
          )
          stub_local_links_manager_has_a_local_authority("Achester", local_custodian_code: 1)
          stub_local_links_manager_has_a_local_authority("Beechester", local_custodian_code: 2)
          stub_local_links_manager_has_a_local_authority("Ceechester", local_custodian_code: 3)
          visit "/find-local-council"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find")
        end

        it "includes the select address text in the title element" do
          expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.select_address').downcase} - GOV.UK", exact: true)
        end

        it "prompts you to choose your address" do
          expect(page).to have_content("Select an address")
        end

        it "displays a radio buttons" do
          expect(page).to have_css(".govuk-radios")
        end

        it "contains a list of addresses mapped to authority slugs" do
          expect(page).to have_content("House 1")
          expect(page).to have_content("House 2")
          expect(page).to have_content("House 3")
        end

        it "redirects to the correct authority when an address is chosen" do
          choose("House 2")
          click_on("Continue")

          expect(page).to have_content("Your local authority is Beechester.")
        end
      end

      context "when multiple authorities (6 or more) are found" do
        before do
          stub_locations_api_has_location(
            "CH25 9BJ",
            [
              { "address" => "House 1", "local_custodian_code" => "1" },
              { "address" => "House 2", "local_custodian_code" => "2" },
              { "address" => "House 3", "local_custodian_code" => "3" },
              { "address" => "House 4", "local_custodian_code" => "4" },
              { "address" => "House 5", "local_custodian_code" => "5" },
              { "address" => "House 6", "local_custodian_code" => "6" },
              { "address" => "House 7", "local_custodian_code" => "7" },
            ],
          )
          stub_local_links_manager_has_a_local_authority("Achester", local_custodian_code: 1)
          stub_local_links_manager_has_a_local_authority("Beechester", local_custodian_code: 2)
          stub_local_links_manager_has_a_local_authority("Ceechester", local_custodian_code: 3)
          stub_local_links_manager_has_a_local_authority("Deechester", local_custodian_code: 4)
          stub_local_links_manager_has_a_local_authority("Eeechester", local_custodian_code: 5)
          stub_local_links_manager_has_a_local_authority("Feechester", local_custodian_code: 6)
          stub_local_links_manager_has_a_local_authority("Geechester", local_custodian_code: 7)
          visit "/find-local-council"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find")
        end

        it "includes the select address text in the title element" do
          expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.select_address').downcase} - GOV.UK", exact: true)
        end

        it "prompts you to choose your address" do
          expect(page).to have_content("Select an address")
        end

        it "displays a dropdown select" do
          expect(page).to have_css(".govuk-select")
        end

        it "contains a list of addresses mapped to authority slugs" do
          expect(page).to have_content("House 1")
          expect(page).to have_content("House 2")
          expect(page).to have_content("House 3")
          expect(page).to have_content("House 4")
          expect(page).to have_content("House 5")
          expect(page).to have_content("House 6")
          expect(page).to have_content("House 7")
        end
      end

      context "when no local council is found" do
        before do
          stub_locations_api_has_no_location("XM4 5HQ")
          visit "/find-local-council"
          fill_in("postcode", with: "XM4 5HQ")
          click_on("Find")
        end

        it "remains on the find your local council page" do
          expect(page).to have_current_path("/find-local-council", ignore_query: true)
          expect(page).to have_content("Find your local council")
        end

        it "shows an error message" do
          expect(page).to have_content("We couldn't find a council for this postcode.")
        end
      end
    end
  end

  context "when entering a specific local authority slug in the URL" do
    context "with valid slug" do
      before do
        stub_local_links_manager_has_a_local_authority("islington")
        visit "/find-local-council/islington"
      end

      it "includes the search result text in the page title" do
        expect(page).to have_title("Find your local council: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
      end

      it "shows the local authority result" do
        expect(page).to have_content("Your local authority is")
        within(".unitary-result") do
          expect(page).to have_content("Islington")
          expect(page).to have_link("Go to Islington website", href: "http://islington.example.com", exact: true)
        end
      end
    end

    context "with invalid slug" do
      before do
        stub_local_links_manager_does_not_have_an_authority("hogwarts")
        visit "/find-local-council/hogwarts"
      end

      it "shows an error message" do
        expect(page.status_code).to eq(404)
      end
    end
  end
end

def stub_local_links_manager_has_a_district_and_unitary_local_authority(district_slug, unitary_slug, district_snac: "00AG", unitary_snac: "00LC", local_custodian_code: nil)
  response = {
    "local_authorities" => [
      {
        "name" => district_slug.capitalize,
        "homepage_url" => "http://#{district_slug}.example.com",
        "country_name" => "England",
        "tier" => "district",
        "slug" => district_slug,
        "snac" => district_snac,
      },
      {
        "name" => unitary_slug.capitalize,
        "homepage_url" => "http://#{unitary_slug}.example.com",
        "country_name" => "England",
        "tier" => "unitary",
        "slug" => unitary_slug,
        "snac" => unitary_snac,
      },
    ],
  }

  stub_request(:get, "#{Plek.find('local-links-manager')}/api/local-authority")
    .with(query: { authority_slug: district_slug })
    .to_return(body: response.to_json, status: 200)

  unless local_custodian_code.nil?
    stub_request(:get, "#{Plek.find('local-links-manager')}/api/local-authority")
      .with(query: { local_custodian_code: })
      .to_return(body: response.to_json, status: 200)
  end
end
