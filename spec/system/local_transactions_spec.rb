require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

RSpec.describe "LocalTransactions" do
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  let(:payload) do
    {
      analytics_identifier: nil,
      base_path: "/pay-bear-tax",
      content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
      description: "Descriptive bear text.",
      details: {
        introduction: "Information about paying local tax on owning or looking after a bear.",
        lgil_override: 8,
        lgsl_code: 461,
        scotland_availability: {
          "alternative_url" => "https://scot.gov/service",
          "type" => "devolved_administration_service",
        },
        service_tiers: %w[county unitary],
        wales_availability: {
          "type" => "unavailable",
        },
      },
      document_type: "local_transaction",
      external_related_links: [],
      first_published_at: "2016-02-29T09:24:10.000+00:00",
      format: "local_transaction",
      links: {},
      locale: "en",
      phase: "beta",
      public_updated_at: "2014-12-16T12:49:50.000+00:00",
      publishing_app: "publisher",
      rendering_app: "frontend",
      schema_name: "local_transaction",
      title: "Pay your bear tax",
      updated_at: "2017-01-30T12:30:33.483Z",
      withdrawn_notice: {},
    }
  end

  before do
    configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
    stub_content_store_has_item("/pay-bear-tax", payload)
  end

  context "with a local transaction with an interaction present" do
    before do
      stub_local_links_manager_has_a_link(
        authority_slug: "westminster",
        lgsl: 461,
        lgil: 8,
        url: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update",
        country_name: "England",
        status: "ok",
        local_custodian_code: 5990,
      )
    end

    context "when visiting the local transaction without specifying a location" do
      before { visit "/pay-bear-tax" }

      it "displays the page content" do
        expect(page).to have_title("Pay your bear tax")
        expect(page).to have_content("owning or looking after a bear")
        expect(page).to have_selector(".gem-c-phase-banner")
        expect(page).to have_title("Pay your bear tax - GOV.UK", exact: true)
      end

      it "asks for a postcode" do
        expect(page).to have_field("postcode")
      end

      it "does not show a postcode error" do
        expect(page).not_to have_selector(".location_error")
      end

      it "shows link to postcode_finder" do
        expect(page).to have_selector("a#postcode-finder-link")
      end

      it "has the correct postcode finder button text" do
        expect(page).to have_button("Find your local council")
      end

      it "adds the GA4 form tracker for form_submit events" do
        data_module = page.find("form")["data-module"]
        expected_data_module = "ga4-form-tracker"
        ga4_form_attribute = page.find("form")["data-ga4-form"]
        ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"local transaction\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Pay your bear tax\"}"

        expect(data_module).to eq(expected_data_module)
        expect(ga4_form_attribute).to eq(ga4_expected_object)
      end
    end

    context "when visiting the local transaction with a valid postcode" do
      before do
        visit "/pay-bear-tax"
        fill_in("postcode", with: "SW1A 1AA")
        click_on("Find your local council")
      end

      it "redirects to the appropriate authority slug" do
        expect(page).to have_current_path("/pay-bear-tax/westminster", ignore_query: true)
      end

      it "includes the search result text in the page title" do
        expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
      end

      it "includes the search for another postcode link" do
        expect(page).to have_link("Search for a different postcode", href: "/pay-bear-tax", exact: true)
      end

      it "shows a get started button which links to the interaction" do
        expect(page).to have_button_as_link(
          I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"),
          href: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update",
          rel: "external",
        )
      end

      it "adds the GA4 auto tracker around the result body (form_complete)" do
        data_module = page.find(".interaction p:first-child")["data-module"]
        expected_data_module = "ga4-auto-tracker"
        ga4_auto_attribute = page.find(".interaction p:first-child")["data-ga4-auto"]
        ga4_expected_object = "{\"event_name\":\"form_complete\",\"type\":\"local transaction\",\"text\":\"We’ve matched the postcode to Westminster.\",\"action\":\"complete\",\"tool_name\":\"Pay your bear tax\"}"
        expect(data_module).to eq(expected_data_module)
        expect(ga4_auto_attribute).to eq(ga4_expected_object)
      end

      it "adds the GA4 link tracker around the result link (information_click)" do
        data_module = page.find("#get-started")["data-module"]
        expected_data_module = "ga4-link-tracker"
        ga4_link_attribute = page.find("#get-started")["data-ga4-link"]
        ga4_expected_object = "{\"event_name\":\"information_click\",\"type\":\"local transaction\",\"tool_name\":\"Pay your bear tax\",\"action\":\"information click\"}"
        expect(data_module).to eq(expected_data_module)
        expect(ga4_link_attribute).to eq(ga4_expected_object)
      end

      it "does not show the transaction information" do
        expect(page).not_to have_content("owning or looking after a bear")
      end

      it "does not show a postcode error" do
        expect(page).not_to have_selector(".location_error")
      end

      it "does not show link to change location" do
        expect(page).not_to have_link("(change location)")
      end
    end

    context "when visiting the local transaction with an incorrect postcode" do
      before do
        stub_locations_api_has_no_location("AB1 2AB")
        visit "/pay-bear-tax"
        fill_in("postcode", with: "AB1 2AB")
        click_on("Find your local council")
      end

      it "remains on the pay bear tax page" do
        expect(page).to have_current_path("/pay-bear-tax", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content(I18n.t("formats.local_transaction.valid_postcode_no_match"))
      end

      it "adds the GA4 auto tracker to the error (form_error event)" do
        data_module = page.find("#error")["data-module"]
        expected_data_module = "ga4-auto-tracker govuk-error-summary"
        ga4_error_attribute = page.find("#error")["data-ga4-auto"]
        ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"local transaction\",\"text\":\"We couldn't find this postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Pay your bear tax\"}"

        expect(data_module).to eq(expected_data_module)
        expect(ga4_error_attribute).to eq(ga4_expected_object)
      end
    end

    context "when visiting the local transaction with an invalid postcode" do
      before do
        stub_locations_api_does_not_have_a_bad_postcode("Not valid")
        visit "/pay-bear-tax"
        fill_in("postcode", with: "Not valid")
        click_on("Find your local council")
      end

      it "remains on the local transaction page" do
        expect(page).to have_current_path("/pay-bear-tax", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content(I18n.t("formats.local_transaction.invalid_postcode"))
      end

      it "shows the transaction information" do
        expect(page).to have_content("owning or looking after a bear")
      end

      it "re-populates the invalid input" do
        expect(page).to have_field("postcode", with: "Not valid")
      end
    end

    context "when visiting the local transaction with a blank postcode" do
      before do
        visit "/pay-bear-tax"
        fill_in("postcode", with: "")
        click_on("Find your local council")
      end

      it "remains on the local transaction page" do
        expect(page).to have_current_path("/pay-bear-tax", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content(I18n.t("formats.local_transaction.invalid_postcode"))
      end

      it "prefixes 'Error: ' to the page title tag" do
        expect(page).to have_title("Error: Pay your bear tax - GOV.UK")
      end
    end

    context "when visiting the local transaction with a valid postcode that has no local authority" do
      before do
        stub_locations_api_has_location("XM4 5HQ", [{ "local_custodian_code" => 123 }])
        stub_local_links_manager_does_not_have_a_custodian_code(123)
        visit "/pay-bear-tax"
        fill_in("postcode", with: "XM4 5HQ")
        click_on("Find your local council")
      end

      it "shows an error message" do
        expect(page).to have_content(I18n.t("formats.local_transaction.no_local_authority"))
      end

      it "re-populates the invalid input" do
        expect(page).to have_field("postcode", with: "XM4 5HQ")
      end
    end

    context "when visiting the local transaction with a postcode where multiple authorities are found" do
      context "when there are 5 or fewer addresses to choose from" do
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
          stub_local_links_manager_has_a_link(
            authority_slug: "Beechester",
            lgsl: 461,
            lgil: 8,
            url: "http://www.beechester.gov.uk/what-is-the-deal",
            country_name: "England",
            status: "ok",
            local_custodian_code: 5990,
          )
          visit "/pay-bear-tax"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find your local council")
        end

        it "includes the select address text in the page title" do
          expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
        end

        it "prompts you to choose your address" do
          expect(page).to have_content("Select an address")
        end

        it "displays radio buttons" do
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

          expect(page).to have_content("We’ve matched the postcode to Beechester")
        end
      end

      context "when there are 6 or more addresses to choose from" do
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
          visit "/pay-bear-tax"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find your local council")
        end

        it "includes the search result text in the page title" do
          expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
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
    end
  end

  context "with a local transaction but without an interaction present" do
    before do
      stub_local_links_manager_has_no_link(authority_slug: "westminster", lgsl: 461, lgil: 8, country_name: "England")
    end

    context "when visiting the local transaction without specifying a location" do
      before { visit "/pay-bear-tax" }

      it "displays the default page title" do
        expect(page).to have_title("Pay your bear tax - GOV.UK", exact: true)
      end

      it "displays the page content" do
        expect(page).to have_content("Pay your bear tax")
        expect(page).to have_content("owning or looking after a bear")
      end

      it "asks for a postcode" do
        expect(page).to have_field("postcode")
      end
    end

    context "when visiting the local transaction with a valid postcode" do
      before do
        visit "/pay-bear-tax"
        fill_in("postcode", with: "SW1A 1AA")
        click_on("Find your local council")
      end

      it "redirects to the appropriate authority slug" do
        expect(page).to have_current_path("/pay-bear-tax/westminster", ignore_query: true)
      end

      it "includes the search result text in the page title" do
        expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
      end

      it "shows advisory message that no interaction is available" do
        expect(page).to have_content(I18n.t("formats.local_transaction.unknown_service"))
      end

      it "links to the council website" do
        expect(page).to have_button_as_link(
          I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"),
          href: "http://westminster.example.com",
          rel: "external",
        )
      end

      it "does not show the transaction information" do
        expect(page).not_to have_content("owning or looking after a bear")
      end
    end
  end

  context "with no interaction present and a missing homepage url" do
    before do
      stub_local_links_manager_has_no_link_and_no_homepage_url(authority_slug: "westminster", lgsl: 461, lgil: 8, country_name: "England")
      visit "/pay-bear-tax"
      fill_in("postcode", with: "SW1A 1AA")
      click_on("Find your local council")
    end

    it "redirects to the appropriate authority slug" do
      expect(page).to have_current_path("/pay-bear-tax/westminster", ignore_query: true)
    end

    it "does not link to the authority" do
      expect(page).not_to have_link(I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"))
    end

    it "includes the search result text in the page title" do
      expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    it "shows advisory message that we have no url" do
      expect(page).to have_content(I18n.t("formats.local_transaction.no_website"))
      expect(page).to have_link("local council search", href: "/find-local-council")
    end

    it "does not show the transaction information" do
      expect(page).not_to have_content("owning or looking after a bear")
    end

    it "does not present the form again" do
      expect(page).not_to have_field("postcode")
    end
  end

  context "when a service is unavailable for a devolved administration with an interaction present" do
    before do
      configure_locations_api_and_local_authority("WA8 8DX", %w[cardiff], 6815)
      stub_local_links_manager_has_a_link(
        authority_slug: "cardiff",
        lgsl: 461,
        lgil: 8,
        url: "https://www.cardiff.gov.uk/bear-the-cost-of-grizzly-ownership",
        country_name: "Wales",
        status: "ok",
      )
      visit "/pay-bear-tax"
      fill_in("postcode", with: "WA8 8DX")
      click_on("Find your local council")
    end

    it "includes the search result text in the page title" do
      expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    it "renders results page for an unavailable service" do
      expect(page).to have_content(I18n.t("formats.local_transaction.service_not_available", country_name: "Wales"))
    end

    it "renders matching the postcode to local authority" do
      expect(page.body.include?(I18n.t("formats.local_transaction.matched_postcode_html", local_authority: "Cardiff"))).to be true
    end

    it "shows a button that links to the local authority website" do
      expect(page).to have_button_as_link(
        I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Cardiff"),
        href: "http://cardiff.example.com",
        rel: "external",
      )
    end
  end

  context "when a service is unavailable for a devolved administration without an interaction or homepage present" do
    before do
      configure_locations_api_and_local_authority("WA8 8DX", %w[cardiff], 6815)
      stub_local_links_manager_has_no_link_and_no_homepage_url(authority_slug: "cardiff", lgsl: 461, lgil: 8, country_name: "Wales")
      visit "/pay-bear-tax"
      fill_in("postcode", with: "WA8 8DX")
      click_on("Find your local council")
    end

    it "includes the search result text in the page title" do
      expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    it "renders results page for an unavailable service" do
      expect(page).to have_content(I18n.t("formats.local_transaction.service_not_available", country_name: "Wales"))
    end

    it "renders matching the postcode to local authority" do
      expect(page.body.include?(I18n.t("formats.local_transaction.matched_postcode_html", local_authority: "Cardiff"))).to be true
    end

    it "does not link to the authority" do
      expect(page).not_to have_link(I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Cardiff"))
    end

    it "shows advisory message that we have no url" do
      expect(page.body.include?(I18n.t("formats.local_transaction.no_local_authority_url_html"))).to be true
    end
  end

  context "when a service is handled differently for a devolved administration" do
    before do
      configure_locations_api_and_local_authority("EH8 8DX", %w[edinburgh], 9064)
      stub_local_links_manager_has_a_link(
        authority_slug: "edinburgh",
        lgsl: 461,
        lgil: 8,
        url: "http://www.edinburgh.gov.uk/bear-the-cost-of-grizzly-ownership",
        country_name: "Scotland",
        status: "ok",
      )
      visit "/pay-bear-tax"
      fill_in("postcode", with: "EH8 8DX")
      click_on("Find your local council")
    end

    it "includes the search result text in the page title" do
      expect(page).to have_title("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    it "renders results page for a devolved administration service" do
      expect(page).to have_content(I18n.t("formats.local_transaction.info_on_country_website.scotland"))
    end

    it "shows a button that links to an alternate service provider" do
      expect(page).to have_button_as_link(
        I18n.t("formats.local_transaction.find_info_for", country_name: @country_name),
        href: "https://scot.gov/service",
        rel: "external",
      )
    end
  end
end
