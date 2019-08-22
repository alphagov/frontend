require 'integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/local_links_manager'

class LocalTransactionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  setup do
    mapit_has_a_postcode_and_areas("SW1A 1AA", [51.5010096, -0.1415870], [
      { "ons" => "00BK", "name" => "Westminster City Council", "type" => "LBO", "govuk_slug" => "westminster" },
      { "name" => "Greater London Authority", "type" => "GLA" }
    ])

    westminster = {
      "id" => 2432,
      "codes" => {
        "ons" => "00BK",
        "gss" => "E07000198",
        "govuk_slug" => "westminster"
      },
      "name" => "Westminster"
    }

    mapit_has_area_for_code('govuk_slug', 'westminster', westminster)

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
        service_tiers: %w(county unitary),
        introduction: "Information about paying local tax on owning or looking after a bear."
      },
      external_related_links: []
    }

    content_store_has_item('/pay-bear-tax', @payload)
  end

  context "given a local transaction with an interaction present" do
    setup do
      local_links_manager_has_a_link(
        authority_slug: "westminster",
        lgsl: 461,
        lgil: 8,
        url: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update"
      )
    end

    context "when visiting the local transaction without specifying a location" do
      setup do
        visit '/pay-bear-tax'
      end

      should "display the page content" do
        assert_has_component_title "Pay your bear tax"
        assert page.has_content? "owning or looking after a bear"
        assert page.has_selector?(".gem-c-phase-banner")
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

      should "add google analytics tags for postcodeSearchStarted" do
        track_category = page.find('.postcode-search-form')['data-track-category']
        track_action = page.find('.postcode-search-form')['data-track-action']

        assert_equal "postcodeSearch:local_transaction", track_category
        assert_equal "postcodeSearchStarted", track_action
      end
    end

    context "when visiting the local transaction with a valid postcode" do
      setup do
        visit '/pay-bear-tax'
        fill_in 'postcode', with: "SW1A 1AA"
        click_on 'Find'
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "show a get started button which links to the interaction" do
        assert_has_button_as_link("Go to their website",
                                  href: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update",
                                  rel: "external",
                                  start: true)
      end

      should "not show the transaction information" do
        assert_not page.has_content?("owning or looking after a bear")
      end

      should "not show a postcode error" do
        assert_not page.has_selector?(".location_error")
      end

      should "show link to change location" do
        assert page.has_link?('Back')
        assert_not page.has_link?('(change location)')
      end
    end

    context "when visiting the local transaction with an incorrect postcode" do
      setup do
        mapit_does_not_have_a_postcode("AB1 2AB")

        visit '/pay-bear-tax'

        fill_in 'postcode', with: "AB1 2AB"
        click_on 'Find'
      end

      should "remain on the pay bear tax page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find this postcode."
        assert page.has_content? "Check it and enter it again."
      end

      should "populate google analytics tags" do
        track_action = page.find('.gem-c-error-alert')['data-track-action']
        track_label = page.find('.gem-c-error-alert')['data-track-label']

        assert_equal "postcodeErrorShown: fullPostcodeNoMapitMatch", track_action
        assert_equal "We couldn't find this postcode.", track_label
      end
    end

    context "when visiting the local transaction with an invalid postcode" do
      setup do
        mapit_does_not_have_a_bad_postcode("Not valid")

        visit '/pay-bear-tax'
        fill_in 'postcode', with: "Not valid"
        click_on 'Find'
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "This isn't a valid postcode"
      end

      should "see the transaction information" do
        assert page.has_content? "owning or looking after a bear"
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "Not valid"
      end

      should "populate google analytics tags" do
        track_action = page.find('.gem-c-error-alert')['data-track-action']
        track_label = page.find('.gem-c-error-alert')['data-track-label']

        assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
        assert_equal "This isn't a valid postcode.", track_label
      end
    end

    context "when visiting the local transaction with a banned postcode" do
      setup do
        visit '/pay-bear-tax'
        fill_in 'postcode', with: "ENTERPOSTCODE"
        click_on 'Find'
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "This isn't a valid postcode"
      end

      should "see the transaction information" do
        assert page.has_content? "owning or looking after a bear"
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "ENTERPOSTCODE"
      end

      should "populate google analytics tags" do
        track_action = page.find('.gem-c-error-alert')['data-track-action']
        track_label = page.find('.gem-c-error-alert')['data-track-label']

        assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
        assert_equal "This isn't a valid postcode.", track_label
      end
    end

    context "when visiting the local transaction with a blank postcode" do
      setup do
        visit '/pay-bear-tax'
        fill_in 'postcode', with: ""
        click_on 'Find'
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "This isn't a valid postcode"
      end

      should "populate google analytics tags" do
        track_action = page.find('.gem-c-error-alert')['data-track-action']
        track_label = page.find('.gem-c-error-alert')['data-track-label']

        assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
        assert_equal "This isn't a valid postcode.", track_label
      end
    end

    context "when visiting the local transaction with a valid postcode that has no areas in MapIt" do
      setup do
        mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], {})

        visit '/pay-bear-tax'
        fill_in 'postcode', with: "XM4 5HQ"
        click_on 'Find'
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find a council for this postcode."
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "XM4 5HQ"
      end

      should "populate google analytics tags" do
        track_action = page.find('.gem-c-error-alert')['data-track-action']
        track_label = page.find('.gem-c-error-alert')['data-track-label']

        assert_equal "postcodeErrorShown: noLaMatch", track_action
        assert_equal "We couldn't find a council for this postcode.", track_label
      end
    end
  end

  context "given a local transaction without an interaction present" do
    setup do
      local_links_manager_has_no_link(
        authority_slug: 'westminster',
        lgsl: 461,
        lgil: 8
      )
    end

    context "when visiting the local transaction without specifying a location" do
      setup do
        visit '/pay-bear-tax'
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
        visit '/pay-bear-tax'
        fill_in 'postcode', with: "SW1A 1AA"
        click_on 'Find'
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "show advisory message that no interaction is available" do
        assert page.has_content?("Search the Westminster website for this service")
      end

      should 'link to the council website' do
        assert_has_button_as_link("Go to their website",
                                  href: "http://westminster.example.com",
                                  rel: "external",
                                  start: true)
      end

      should "not show the transaction information" do
        assert_not page.has_content?("owning or looking after a bear")
      end

      should "show back link to go back and try a different postcode" do
        assert page.has_link?('Back')
      end

      should "add google analytics tags" do
        track_category = page.find('.local-authority-result')['data-track-category']
        track_action = page.find('.local-authority-result')['data-track-action']

        assert_equal "userAlerts:local_transaction", track_category
        assert_equal "postcodeResultShown:laMatchNoLink", track_action
      end
    end
  end

  context "given no interaction present and a missing homepage url" do
    setup do
      local_links_manager_has_no_link_and_no_homepage_url(
        authority_slug: 'westminster',
        lgsl: 461,
        lgil: 8,
      )

      visit '/pay-bear-tax'
      fill_in 'postcode', with: "SW1A 1AA"

      click_on 'Find'
    end

    should "redirect to the appropriate authority slug" do
      assert_equal "/pay-bear-tax/westminster", current_path
    end

    should "not link to the authority" do
      assert page.has_no_link?("Go to their website")
    end

    should "show advisory message that we have no url" do
      assert page.has_content?("We don't have a link for their website.")
      assert page.has_link?("local council search", href: "/find-local-council")
    end

    should "not see the transaction information" do
      assert page.has_no_content? "owning or looking after a bear"
    end

    should "not present the form again" do
      assert page.has_no_field? "postcode"
    end

    should "show back link to go back and try a different postcode" do
      assert page.has_link?('Back')
    end

    should "add google analytics tags" do
      track_category = page.find('.local-authority-result')['data-track-category']
      track_action = page.find('.local-authority-result')['data-track-action']

      assert_equal "userAlerts:local_transaction", track_category
      assert_equal "postcodeResultShown:laMatchNoLinkNoAuthorityUrl", track_action
    end
  end

  should "gracefully handle missing snac in mapit data" do
    mapit_has_a_postcode_and_areas("AL10 9AB", [51.75287647301734, -0.24217323267679933], [
      { "name" => "Welwyn Hatfield Borough Council", "type" => "DIS" },
    ])

    visit '/pay-bear-tax'
    fill_in 'postcode', with: "AL10 9AB"
    click_on 'Find'

    assert_current_url "/pay-bear-tax"
    assert_selector(".gem-c-error-alert", text: "We couldn't find a council for this postcode")
  end
end
