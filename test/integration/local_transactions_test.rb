require "integration_test_helper"
require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

class LocalTransactionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  setup do
    configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)

    @payload = {
      analytics_identifier: nil,
      base_path: "/pay-bear-tax",
      content_id: "d6d6caaf-77db-47e1-8206-30cd4f3d0e3f",
      document_type: "local_transaction",
      first_published_at: "2016-02-29T09:24:10.000+00:00",
      format: "local_transaction",
      locale: "en",
      phase: "beta",
      public_updated_at: "2014-12-16T12:49:50.000+00:00",
      publishing_app: "publisher",
      rendering_app: "frontend",
      schema_name: "local_transaction",
      title: "Pay your bear tax",
      updated_at: "2017-01-30T12:30:33.483Z",
      withdrawn_notice: {},
      links: {},
      description: "Descriptive bear text.",
      details: {
        lgsl_code: 461,
        lgil_override: 8,
        service_tiers: %w[county unitary],
        introduction: "Information about paying local tax on owning or looking after a bear.",
        scotland_availability: { "type" => "devolved_administration_service", "alternative_url" => "https://scot.gov/service" },
        wales_availability: { "type" => "unavailable" },
      },
      external_related_links: [],
    }

    stub_content_store_has_item("/pay-bear-tax", @payload)
  end

  context "given a local transaction with an interaction present" do
    setup do
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
      setup do
        visit "/pay-bear-tax"
      end

      should "display the page content" do
        assert_has_component_title "Pay your bear tax"
        assert page.has_content? "owning or looking after a bear"
        assert page.has_selector?(".gem-c-phase-banner")
        assert page.has_title?("Pay your bear tax - GOV.UK", exact: true)
      end

      should "ask for a postcode" do
        assert page.has_field? "postcode"
      end

      should "not show a postcode error" do
        assert_not page.has_selector?(".location_error")
      end

      should "show link to postcode_finder" do
        assert page.has_selector?("a#postcode-finder-link")
      end

      should "add the GA4 form tracker for form_submit events" do
        data_module = page.find("form")["data-module"]
        expected_data_module = "ga4-form-tracker"

        ga4_form_attribute = page.find("form")["data-ga4-form"]
        ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"local transaction\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Pay your bear tax\"}"

        assert_equal expected_data_module, data_module
        assert_equal ga4_expected_object, ga4_form_attribute
      end
    end

    context "when visiting the local transaction with a valid postcode" do
      setup do
        visit "/pay-bear-tax"
        fill_in "postcode", with: "SW1A 1AA"
        click_on "Find"
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "include the search result text in the page title" do
        assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
      end

      should "show a get started button which links to the interaction" do
        assert_has_button_as_link(
          I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"),
          href: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update",
          rel: "external",
        )
      end

      should "add the GA4 auto tracker around the result body (form_complete)" do
        data_module = page.find(".interaction p:first-child")["data-module"]
        expected_data_module = "auto-track-event ga4-auto-tracker"

        ga4_auto_attribute = page.find(".interaction p:first-child")["data-ga4-auto"]
        ga4_expected_object = "{\"event_name\":\"form_complete\",\"type\":\"local transaction\",\"text\":\"We've matched the postcode to Westminster.\",\"action\":\"complete\",\"tool_name\":\"Pay your bear tax\"}"

        assert_equal expected_data_module, data_module
        assert_equal ga4_expected_object, ga4_auto_attribute
      end

      should "add the GA4 link tracker around the result link (information_click)" do
        data_module = page.find("#get-started")["data-module"]
        expected_data_module = "ga4-link-tracker"

        ga4_link_attribute = page.find("#get-started")["data-ga4-link"]
        ga4_expected_object = "{\"event_name\":\"information_click\",\"type\":\"local transaction\",\"tool_name\":\"Pay your bear tax\",\"action\":\"information click\"}"

        assert_equal expected_data_module, data_module
        assert_equal ga4_expected_object, ga4_link_attribute
      end

      should "not show the transaction information" do
        assert_not page.has_content?("owning or looking after a bear")
      end

      should "not show a postcode error" do
        assert_not page.has_selector?(".location_error")
      end

      should "show link to change location" do
        assert_not page.has_link?("(change location)")
      end
    end

    context "when visiting the local transaction with an incorrect postcode" do
      setup do
        stub_locations_api_has_no_location("AB1 2AB")

        visit "/pay-bear-tax"

        fill_in "postcode", with: "AB1 2AB"
        click_on "Find"
      end

      should "remain on the pay bear tax page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? I18n.t("formats.local_transaction.valid_postcode_no_match")
      end

      should "add the GA4 auto tracker to the error (form_error event)" do
        data_module = page.find("#error")["data-module"]
        expected_data_module = "auto-track-event ga4-auto-tracker govuk-error-summary"

        ga4_error_attribute = page.find("#error")["data-ga4-auto"]
        ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"local transaction\",\"text\":\"We couldn't find this postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Pay your bear tax\"}"

        assert_equal expected_data_module, data_module
        assert_equal ga4_expected_object, ga4_error_attribute
      end

      should "populate google analytics tags" do
        track_action = page.find(".gem-c-error-summary")["data-track-action"]
        track_label = page.find(".gem-c-error-summary")["data-track-label"]

        assert_equal "postcodeErrorShown: fullPostcodeNoLocationsApiMatch", track_action

        assert_equal I18n.t("formats.local_transaction.valid_postcode_no_match"), track_label
      end
    end

    context "when visiting the local transaction with an invalid postcode" do
      setup do
        stub_locations_api_does_not_have_a_bad_postcode("Not valid")

        visit "/pay-bear-tax"
        fill_in "postcode", with: "Not valid"
        click_on "Find"
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? I18n.t("formats.local_transaction.invalid_postcode")
      end

      should "see the transaction information" do
        assert page.has_content? "owning or looking after a bear"
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "Not valid"
      end

      should "populate google analytics tags" do
        track_action = page.find(".gem-c-error-summary")["data-track-action"]
        track_label = page.find(".gem-c-error-summary")["data-track-label"]

        assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
        assert_equal I18n.t("formats.local_transaction.invalid_postcode"), track_label
      end
    end

    context "when visiting the local transaction with a blank postcode" do
      setup do
        visit "/pay-bear-tax"
        fill_in "postcode", with: ""
        click_on "Find"
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? I18n.t("formats.local_transaction.invalid_postcode")
      end

      should "prefix 'Error: ' to the page title tag" do
        assert page.has_title?("Error: Pay your bear tax - GOV.UK")
      end

      should "populate google analytics tags" do
        track_action = page.find(".gem-c-error-summary")["data-track-action"]
        track_label = page.find(".gem-c-error-summary")["data-track-label"]

        assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
        assert_equal I18n.t("formats.local_transaction.invalid_postcode"), track_label
      end
    end

    context "when visiting the local transaction with a valid postcode that has no local authority" do
      setup do
        stub_locations_api_has_location("XM4 5HQ", [{ "local_custodian_code" => 123 }])
        stub_local_links_manager_does_not_have_a_custodian_code(123)

        visit "/pay-bear-tax"
        fill_in "postcode", with: "XM4 5HQ"
        click_on "Find"
      end

      should "see an error message" do
        assert page.has_content? I18n.t("formats.local_transaction.no_local_authority")
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "XM4 5HQ"
      end

      should "populate google analytics tags" do
        track_action = page.find(".gem-c-error-summary")["data-track-action"]
        track_label = page.find(".gem-c-error-summary")["data-track-label"]

        assert_equal "postcodeErrorShown: noLaMatch", track_action
        assert_equal I18n.t("formats.local_transaction.no_local_authority"), track_label
      end
    end

    context "when visiting the local transaction with a postcode where multiple authorities are found" do
      context "when there are 5 or fewer addresses to choose from" do
        setup do
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

          visit "/pay-bear-tax"
          fill_in "postcode", with: "CH25 9BJ"
          click_on "Find"
        end

        should "include the select address text in the page title" do
          assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
        end

        should "prompt you to choose your address" do
          assert page.has_content?("Select an address")
        end

        should "display radio buttons" do
          assert page.has_css?(".govuk-radios")
        end

        should "contain a list of addresses mapped to authority slugs" do
          assert page.has_content?("House 1")
          assert page.has_content?("House 2")
          assert page.has_content?("House 3")
        end
      end

      context "when there are 6 or more addresses to choose from" do
        setup do
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
          fill_in "postcode", with: "CH25 9BJ"
          click_on "Find"
        end

        should "include the search result text in the page title" do
          assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
        end

        should "prompt you to choose your address" do
          assert page.has_content?("Select an address")
        end

        should "display a dropdown select" do
          assert page.has_css?(".govuk-select")
        end

        should "contain a list of addresses mapped to authority slugs" do
          assert page.has_content?("House 1")
          assert page.has_content?("House 2")
          assert page.has_content?("House 3")
          assert page.has_content?("House 4")
          assert page.has_content?("House 5")
          assert page.has_content?("House 6")
          assert page.has_content?("House 7")
        end
      end
    end
  end

  context "given a local transaction without an interaction present" do
    setup do
      stub_local_links_manager_has_no_link(
        authority_slug: "westminster",
        lgsl: 461,
        lgil: 8,
        country_name: "England",
      )
    end

    context "when visiting the local transaction without specifying a location" do
      setup do
        visit "/pay-bear-tax"
      end

      should "display the default page title" do
        assert page.has_title?("Pay your bear tax - GOV.UK", exact: true)
      end

      should "display the page content" do
        assert page.has_content? "Pay your bear tax"
        assert page.has_content? "owning or looking after a bear"
      end

      should "ask for a postcode" do
        assert page.has_field? "postcode"
      end
    end

    context "when visiting the local transaction with a valid postcode" do
      setup do
        visit "/pay-bear-tax"
        fill_in "postcode", with: "SW1A 1AA"
        click_on "Find"
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "include the search result text in the page title" do
        assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
      end

      should "show advisory message that no interaction is available" do
        assert page.has_content?(I18n.t("formats.local_transaction.unknown_service"))
      end

      should "link to the council website" do
        assert_has_button_as_link(
          I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"),
          href: "http://westminster.example.com",
          rel: "external",
        )
      end

      should "not show the transaction information" do
        assert_not page.has_content?("owning or looking after a bear")
      end

      should "add google analytics tags" do
        track_category = page.find(".local-authority-result")["data-track-category"]
        track_action = page.find(".local-authority-result")["data-track-action"]

        assert_equal "userAlerts:local_transaction", track_category
        assert_equal "postcodeResultShown:laMatchNoLink", track_action
      end
    end
  end

  context "given no interaction present and a missing homepage url" do
    setup do
      stub_local_links_manager_has_no_link_and_no_homepage_url(
        authority_slug: "westminster",
        lgsl: 461,
        lgil: 8,
        country_name: "England",
      )

      visit "/pay-bear-tax"
      fill_in "postcode", with: "SW1A 1AA"

      click_on "Find"
    end

    should "redirect to the appropriate authority slug" do
      assert_equal "/pay-bear-tax/westminster", current_path
    end

    should "not link to the authority" do
      assert page.has_no_link?(I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Westminster"))
    end

    should "include the search result text in the page title" do
      assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    should "show advisory message that we have no url" do
      assert page.has_content?(I18n.t("formats.local_transaction.no_website"))
      assert page.has_link?("local council search", href: "/find-local-council")
    end

    should "not see the transaction information" do
      assert page.has_no_content? "owning or looking after a bear"
    end

    should "not present the form again" do
      assert page.has_no_field? "postcode"
    end

    should "add google analytics tags" do
      track_category = page.find(".local-authority-result")["data-track-category"]
      track_action = page.find(".local-authority-result")["data-track-action"]

      assert_equal "userAlerts:local_transaction", track_category
      assert_equal "postcodeResultShown:laMatchNoLinkNoAuthorityUrl", track_action
    end
  end

  context "when a service is unavailable for a devolved administration with an interaction present" do
    setup do
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
      fill_in "postcode", with: "WA8 8DX"
      click_on "Find"
    end

    should "include the search result text in the page title" do
      assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    should "render results page for an unavailable service" do
      assert page.has_content? I18n.t("formats.local_transaction.service_not_available", country_name: "Wales")
    end

    should "render matching the postcode to local authority" do
      assert page.body.include?(I18n.t("formats.local_transaction.matched_postcode_html", local_authority: "Cardiff"))
    end

    should "show a button that links to the local authority website" do
      assert_has_button_as_link(
        I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Cardiff"),
        href: "http://cardiff.example.com",
        rel: "external",
      )
    end
  end

  context "when a service is unavailable for a devolved administration without an interaction or homepage present" do
    setup do
      configure_locations_api_and_local_authority("WA8 8DX", %w[cardiff], 6815)

      stub_local_links_manager_has_no_link_and_no_homepage_url(
        authority_slug: "cardiff",
        lgsl: 461,
        lgil: 8,
        country_name: "Wales",
      )

      visit "/pay-bear-tax"
      fill_in "postcode", with: "WA8 8DX"
      click_on "Find"
    end

    should "include the search result text in the page title" do
      assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    should "render results page for an unavailable service" do
      assert page.has_content? I18n.t("formats.local_transaction.service_not_available", country_name: "Wales")
    end

    should "render matching the postcode to local authority" do
      assert page.body.include?(I18n.t("formats.local_transaction.matched_postcode_html", local_authority: "Cardiff"))
    end

    should "not link to the authority" do
      assert page.has_no_link?(I18n.t("formats.local_transaction.local_authority_website", local_authority_name: "Cardiff"))
    end

    should "show advisory message that we have no url" do
      assert page.body.include?(I18n.t("formats.local_transaction.no_local_authority_url_html"))
    end
  end

  context "when a service is handled differently for a devolved administration" do
    setup do
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
      fill_in "postcode", with: "EH8 8DX"
      click_on "Find"
    end

    should "include the search result text in the page title" do
      assert page.has_title?("Pay your bear tax: #{I18n.t('formats.local_transaction.search_result')} - GOV.UK", exact: true)
    end

    should "render results page for a devolved administration service" do
      assert page.has_content? I18n.t("formats.local_transaction.info_on_country_website.scotland")
    end

    should "show a button that links to an alternate service provider" do
      assert_has_button_as_link(
        I18n.t("formats.local_transaction.find_info_for", country_name: @country_name),
        href: "https://scot.gov/service",
        rel: "external",
      )
    end
  end
end
