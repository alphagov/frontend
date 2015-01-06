require_relative '../integration_test_helper'
require 'gds_api/test_helpers/mapit'

class LocalTransactionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit

  setup do
    mapit_has_a_postcode_and_areas("SW1A 1AA", [51.5010096, -0.1415870], [
      { "ons" => "00BK", "name" => "Westminster City Council", "type" => "LBO" },
      { "name" => "Greater London Authority", "type" => "GLA" }
    ])

    @artefact = artefact_for_slug('pay-bear-tax').merge({
      "title" => "Pay your bear tax",
      "format" => "local_transaction",
      "in_beta" => true,
      "details" => {
        "format" => "LocalTransaction",
        "introduction" => "Information about paying local tax on owning or looking after a bear.",
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
      content_api_has_an_artefact_with_snac_code('pay-bear-tax', '00BK', @artefact.deep_merge({
        "details" => {
          "local_authority" => {
            "name" => "Westminster City Council",
            "snac" => "00BK",
            "tier" => "district",
            "contact_address" => [
              "123 Example Street",
              "SW1A 1AA"
            ],
            "contact_url" => "http://www.westminster.gov.uk/",
            "contact_phone" => "020 1234 567",
            "contact_email" => "info@westminster.gov.uk",
          },
          "local_interaction" => {
            "lgsl_code" => 461,
            "lgil_code" => 8,
            "url" => "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership"
          }
        }
      }))
    end

    context "when visiting the local transaction without specifying a location" do
      setup do
        visit '/pay-bear-tax'
      end

      should "display the page content" do
        assert page.has_content? "Pay your bear tax"
        assert page.has_content? "owning or looking after a bear"
        assert page.has_content? "This part of GOV.UK is being rebuilt"
      end

      should "ask for a postcode" do
        assert page.has_field? "postcode"
      end

      should "not show a postcode error" do
        assert !page.has_selector?(".location_error")
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
        assert page.has_link?("Start now", :href => "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership")
      end

      should "not show a postcode error" do
        assert !page.has_selector?(".location_error")
      end

      should "show link to change location" do
        assert page.has_link?('(change location)')
      end

      should "not show any authority contact details" do
        within('.contact') do
          assert !page.has_content?("123 Example Street")
          assert !page.has_content?("SW1A 1AA")
          assert !page.has_content?("020 1234 567")
        end
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
        assert page.has_content? "Please enter a valid full UK postcode."
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
        assert page.has_content? "Please enter a valid full UK postcode."
      end
    end
  end

  context "given a local transaction without an interaction present" do
    setup do
      content_api_has_an_artefact_with_snac_code('pay-bear-tax', '00BK', @artefact.deep_merge({
        "details" => {
          "local_authority" => {
            "name" => "Westminster City Council",
            "snac" => "00BK",
            "tier" => "district",
            "contact_address" => [
              "123 Example Street",
              "SW1A 1AA"
            ],
            "contact_url" => "http://www.westminster.gov.uk/",
            "contact_phone" => "020 1234 567",
            "contact_email" => "info@westminster.gov.uk",
          },
          "local_interaction" => nil
        }
      }))
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
        assert page.has_content?("We don't have a direct link to this service from Westminster City Council")
      end

      should "show link to change location" do
        assert page.has_link?('(change location)')
      end

      should "show contact details for the authority" do
        within('.contact') do
          assert page.has_content?("123 Example Street")
          assert page.has_content?("SW1A 1AA")
          assert page.has_content?("020 1234 567")
        end
      end
    end
  end

  context "where a local authority does not have complete data" do
    describe "an empty contact url" do
      setup do
        content_api_has_an_artefact_with_snac_code('pay-bear-tax', '00BK', @artefact.deep_merge({
          "details" => {
            "local_authority" => {
              "name" => "Westminster City Council",
              "snac" => "00BK",
              "tier" => "district",
              "contact_address" => [
                "123 Example Street",
                "SW1A 1AA"
              ],
              "contact_url" => "",
              "contact_phone" => "020 1234 567",
              "contact_email" => "info@westminster.gov.uk",
            },
            "local_interaction" => nil
          }
        }))

        visit '/pay-bear-tax'
        fill_in 'postcode', :with => "SW1A 1AA"
        click_button('Find')
      end

      should "display the authority name" do
        assert page.has_content?("service is provided by Westminster City Council")
      end

      should "not link to the authority" do
        assert page.has_no_link?("Westminster City Council")
        assert page.has_no_content?("you could try the Westminster City Council website")
      end
    end

    should "not display the telephone number when it is blank" do
      content_api_has_an_artefact_with_snac_code('pay-bear-tax', '00BK', @artefact.deep_merge({
        "details" => {
          "local_authority" => {
            "name" => "Westminster City Council",
            "snac" => "00BK",
            "tier" => "district",
            "contact_address" => [
              "123 Example Street",
              "SW1A 1AA"
            ],
            "contact_url" => "http://www.westminster.gov.uk/",
            "contact_phone" => "",
            "contact_email" => "info@westminster.gov.uk",
          },
          "local_interaction" => nil
        }
      }))

      visit '/pay-bear-tax'
      fill_in 'postcode', :with => "SW1A 1AA"
      click_button('Find')

      within(:css, ".contact") do
        assert page.has_no_content?("Telephone")
      end
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
    assert page.has_content?("Sorry, we can't find the local council for your postcode. Try using the local council directory.")
  end
end
