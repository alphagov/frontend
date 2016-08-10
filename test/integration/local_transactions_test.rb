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

    @artefact = artefact_for_slug('pay-bear-tax').merge({
      "title" => "Pay your bear tax",
      "format" => "local_transaction",
      "in_beta" => true,
      "details" => {
        "format" => "LocalTransaction",
        "introduction" => "Information about paying local tax on owning or looking after a bear.",
        "lgsl_code" => 461,
        "lgil_override" => 8,
        "local_service" => {
          "description" => "Find out about paying your bear tax",
          "lgsl_code" => 461,
          "providing_tier" => [
            "district",
            "unitary",
            "county"
          ]
        }
      }
    })

    content_api_has_an_artefact('pay-bear-tax', @artefact)
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
        assert page.has_content? "Pay your bear tax"
        assert page.has_content? "owning or looking after a bear"
        assert page.has_selector?(shared_component_selector('beta_label'))
      end

      should "ask for a postcode" do
        assert page.has_field? "postcode"
      end

      should "not show a postcode error" do
        assert !page.has_selector?(".location_error")
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
        fill_in 'postcode', :with => "SW1A 1AA"
        click_button('Find')
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "show a get started button which links to the interaction" do
        assert page.has_link?("Go to their website", href: "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership-2016-update")
      end

      should "not show the transaction information" do
        assert !page.has_content?("owning or looking after a bear")
      end

      should "not show a postcode error" do
        assert !page.has_selector?(".location_error")
      end

      should "show link to change location" do
        assert page.has_link?('Back')
        assert !page.has_link?('(change location)')
      end
    end

    context "when visiting the local transaction with an incorrect postcode" do
      setup do
        mapit_does_not_have_a_postcode("AB1 2AB")

        visit '/pay-bear-tax'

        fill_in 'postcode', with: "AB1 2AB"
        click_button('Find')
      end

      should "remain on the pay bear tax page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find this postcode."
        assert page.has_content? "Check it and enter it again."
      end

      should "populate google analytics tags" do
        track_action = page.find('.error-summary')['data-track-action']
        track_label = page.find('.error-summary')['data-track-label']

        assert_equal "postcodeErrorShown:fullPostcodeNoMapitMatch", track_action
        assert_equal "We couldn't find this postcode.", track_label
      end
    end

    context "when visiting the local transaction with an invalid postcode" do
      setup do
        mapit_does_not_have_a_bad_postcode("Not valid")

        visit '/pay-bear-tax'
        fill_in 'postcode', :with => "Not valid"
        click_button('Find')
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
        track_action = page.find('.error-summary')['data-track-action']
        track_label = page.find('.error-summary')['data-track-label']

        assert_equal "postcodeErrorShown:invalidPostcodeFormat", track_action
        assert_equal "This isn't a valid postcode.", track_label
      end
    end

    context "when visiting the local transaction with a blank postcode" do
      setup do
        visit '/pay-bear-tax'
        fill_in 'postcode', :with => ""
        click_button('Find')
      end

      should "remain on the local transaction page" do
        assert_equal "/pay-bear-tax", current_path
      end

      should "see an error message" do
        assert page.has_content? "This isn't a valid postcode"
      end

      should "populate google analytics tags" do
        track_action = page.find('.error-summary')['data-track-action']
        track_label = page.find('.error-summary')['data-track-label']

        assert_equal "postcodeErrorShown:invalidPostcodeFormat", track_action
        assert_equal "This isn't a valid postcode.", track_label
      end
    end

    context "when visiting the local transaction with a valid postcode that has no areas in MapIt" do
      setup do
        mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], {})

        visit '/pay-bear-tax'
        fill_in 'postcode', with: "XM4 5HQ"
        click_button('Find')
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find a council for this postcode."
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "XM4 5HQ"
      end

      should "populate google analytics tags" do
        track_action = page.find('.error-summary')['data-track-action']
        track_label = page.find('.error-summary')['data-track-label']

        assert_equal "postcodeErrorShown:noLaMatch", track_action
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
        fill_in 'postcode', :with => "SW1A 1AA"
        click_button('Find')
      end

      should "redirect to the appropriate authority slug" do
        assert_equal "/pay-bear-tax/westminster", current_path
      end

      should "show advisory message that no interaction is available" do
        assert page.has_content?("Search the Westminster website for this service")
      end

      should 'link to the council website' do
        assert page.has_link?("Go to their website", href: 'http://westminster.example.com')
      end

      should "not show the transaction information" do
        assert !page.has_content?("owning or looking after a bear")
      end

      should "show back link to go back and try a different postcode" do
        assert page.has_link?('Back')
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
      click_button('Find')
    end

    should "redirect to the appropriate authority slug" do
      assert_equal "/pay-bear-tax/westminster", current_path
    end

    should "not link to the authority" do
      assert page.has_no_link?("Go to their website")
    end

    should "show advisory message that we have no url" do
      assert page.has_content?("We don't have a link for their website.")
      assert page.has_link?("local council search", href: "/find-your-local-council")
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
  end

  should "gracefully handle missing snac in mapit data" do
    mapit_has_a_postcode_and_areas("AL10 9AB", [51.75287647301734, -0.24217323267679933], [
      { "name" => "Welwyn Hatfield Borough Council", "type" => "DIS" },
    ])

    visit '/pay-bear-tax'
    fill_in 'postcode', :with => "AL10 9AB"
    click_button('Find')

    assert_current_url "/pay-bear-tax"
    assert_selector(".error-summary", text: "We couldn't find a council for this postcode")
  end
end
