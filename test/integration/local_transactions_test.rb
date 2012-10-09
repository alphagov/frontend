require 'integration_test_helper'

class LocalTransactionsTest < ActionDispatch::IntegrationTest

  setup do
    stub_location_request("SW1A 1AA", {
      "wgs84_lat" => 51.5010096,
      "wgs84_lon" => -0.1415870,
      "areas" => {
        1 => {"id" => 1, "codes" => {"ons" => "00BK"}, "name" => "Westminster City Council", "type" => "LBO" },
        2 => {"id" => 2, "codes" => {"unit_id" => "41441"}, "name" => "Greater London Authority", "type" => "GLA" }
      },
      "shortcuts" => {
        "council" => 1
      }
    })

    @artefact = artefact_for_slug('pay-bear-tax').merge({
      "title" => "Pay your bear tax",
      "format" => "local_transaction",
      "details" => {
        "format" => "LocalTrasnaction",
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

      should "display the authority name" do
        assert page.has_content?("service is provided by Westminster City Council")
      end

      should "show a get started button which links to the interaction" do
        assert page.has_link?("Get started", :href => "http://www.westminster.gov.uk/bear-the-cost-of-grizzly-ownership")
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
        assert page.has_content?("Sorry, we couldn't find details from Westminster City Council for that service in your area.")
      end
    end
  end

end
