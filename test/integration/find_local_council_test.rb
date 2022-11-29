require "integration_test_helper"
require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"

class FindLocalCouncilTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include LocationHelpers

  setup do
    content_store_has_random_item(base_path: "/find-local-council")
  end

  context "when visiting the start page" do
    setup do
      Frontend.stubs(:govuk_website_root).returns("https://www.test.gov.uk")
      visit "/find-local-council"
    end

    should "show Find Local Council start page" do
      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
      assert page.has_field?("postcode")
    end

    should "add google analytics tags for postcodeSearchStarted" do
      track_category = page.find(".postcode-search-form")["data-track-category"]
      track_action = page.find(".postcode-search-form")["data-track-action"]

      assert_equal "postcodeSearch:find_local_council", track_category
      assert_equal "postcodeSearchStarted", track_action
    end

    should "add the description as meta tag for SEO purposes" do
      description = page.find('meta[name="description"]', visible: false)["content"]
      assert_equal "Find your local authority in England, Wales, Scotland and Northern Ireland", description
    end

    should "have the correct titles" do
      assert_has_component_title "Find your local council"
      assert_equal "Find your local council - GOV.UK", page.title
    end
  end

  context "when entering a postcode in the search form" do
    context "for successful postcode lookup" do
      context "for unitary local authority" do
        setup do
          configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)

          visit "/find-local-council"
          fill_in "postcode", with: "SW1A 1AA"
          click_on "Find"
        end

        should "redirect to the authority slug" do
          assert_equal "/find-local-council/westminster", current_path
        end

        should "show the local authority result" do
          assert page.has_content?("Your local authority is")

          within(".unitary-result") do
            assert page.has_content?("Westminster")
            assert page.has_link?("Go to Westminster website", href: "http://westminster.example.com", exact: true)
          end
        end

        should "have the correct titles" do
          assert_has_component_title "Find your local council"
          assert_equal "Find your local council - GOV.UK", page.title
        end

        should "add google analytics for postcodeResultsShown" do
          track_category = page.find(".local-authority-results")["data-track-category"]
          track_action = page.find(".local-authority-results")["data-track-action"]
          track_label = page.find(".local-authority-results")["data-track-label"]

          assert_equal "postcodeSearch:find_local_council", track_category
          assert_equal "postcodeResultShown", track_action
          assert_equal "1 Result", track_label
        end

        should "add google analytics for exit link tracking" do
          track_action = find_link("Go to Westminster website")["data-track-action"]
          assert_equal "unitaryLinkClicked", track_action
        end
      end

      context "for district local authority" do
        setup do
          stub_locations_api_has_location(
            "HP20 1UG",
            [
              {
                "latitude" => 51.5010096,
                "longitude" => -0.1415870,
                "local_custodian_code" => 440,
              },
            ],
          )

          stub_local_links_manager_has_a_district_and_county_local_authority("aylesbury", "buckinghamshire", local_custodian_code: 440)

          visit "/find-local-council"
          fill_in "postcode", with: "HP20 1UG"
          click_on "Find"
        end

        should "redirect to the district authority slug" do
          assert_equal "/find-local-council/aylesbury", current_path
        end

        should "show the local authority results for both district and county" do
          assert page.has_content?("Your postcode is in a county council and a district council")

          assert page.has_selector? ".county-result"
          assert page.has_selector? ".district-result"

          within(".county-result") do
            assert page.has_content?("Buckinghamshire")
            assert page.has_content?("County councils are responsible for services like:")
            assert page.has_link?("buckinghamshire.example.com", href: "http://buckinghamshire.example.com")
          end

          within(".district-result") do
            assert page.has_content?("Aylesbury")
            assert page.has_content?("District councils are responsible for services like:")
            assert page.has_link?("aylesbury.example.com", href: "http://aylesbury.example.com", exact: true)
          end
        end

        should "add google analytics for postcodeResultsShown" do
          track_category = page.find(".local-authority-results")["data-track-category"]
          track_action = page.find(".local-authority-results")["data-track-action"]
          track_label = page.find(".local-authority-results")["data-track-label"]

          assert_equal "postcodeSearch:find_local_council", track_category
          assert_equal "postcodeResultShown", track_action
          assert_equal "2 Results", track_label
        end

        should "show back link" do
          assert page.has_link?("Back", href: "/find-local-council")
        end

        should "add google analytics for exit link tracking" do
          district_track_action = find_link("aylesbury.example.com")["data-track-action"]
          county_track_action = find_link("buckinghamshire.example.com")["data-track-action"]

          assert_equal "districtLinkClicked", district_track_action
          assert_equal "countyLinkClicked", county_track_action
        end
      end

      context "when finding a local council without homepage" do
        setup do
          stub_locations_api_has_location(
            "SW1A 1AA",
            [
              {
                "latitude" => 51.5010096,
                "longitude" => -0.1415870,
                "local_custodian_code" => 5990,
              },
            ],
          )
          stub_local_links_manager_has_a_local_authority_without_homepage("westminster", local_custodian_code: 5990)

          visit "/find-local-council"
          fill_in "postcode", with: "SW1A 1AA"
          click_on "Find"
        end

        should "show advisory message that we have no URL" do
          assert page.has_content? "We don't have a link for their website."
        end
      end
    end

    context "for unsuccessful postcode lookup" do
      context "with invalid postcode" do
        setup do
          stub_locations_api_does_not_have_a_bad_postcode("NO POSTCODE")

          visit "/find-local-council"
          fill_in "postcode", with: "NO POSTCODE"
          click_on "Find"
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
        end

        should "add \"Error:\" to the beginning of the page title" do
          assert page.has_selector?("title", text: "Error: Find your local council - GOV.UK", visible: false)
        end

        should "see an error message" do
          assert page.has_content? "This isn't a valid postcode"
        end

        should "re-populate the invalid input" do
          assert page.has_field? "postcode", with: "NO POSTCODE"
        end

        should "populate google analytics tags" do
          track_action = page.find(".gem-c-error-summary")["data-track-action"]
          track_label = page.find(".gem-c-error-summary")["data-track-label"]

          assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
          assert_equal "This isn't a valid postcode.", track_label
        end
      end

      context "with blank postcode" do
        setup do
          visit "/find-local-council"
          fill_in "postcode", with: ""
          click_on "Find"
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
        end

        should "add \"Error:\" to the beginning of the page title" do
          assert page.has_selector?("title", text: "Error: Find your local council - GOV.UK", visible: false)
        end

        should "see an error message" do
          assert page.has_content? "This isn't a valid postcode"
        end

        should "populate google analytics tags" do
          track_action = page.find(".gem-c-error-summary")["data-track-action"]
          track_label = page.find(".gem-c-error-summary")["data-track-label"]

          assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
          assert_equal "This isn't a valid postcode.", track_label
        end
      end

      context "when multiple authorities (5 or less) are found" do
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

          visit "/find-local-council"
          fill_in "postcode", with: "CH25 9BJ"
          click_on "Find"
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

      context "when multiple authorities (6 or more) are found" do
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

          visit "/find-local-council"
          fill_in "postcode", with: "CH25 9BJ"
          click_on "Find"
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

      context "when no local council is found" do
        setup do
          stub_locations_api_has_no_location("XM4 5HQ")

          visit "/find-local-council"
          fill_in "postcode", with: "XM4 5HQ"
          click_on "Find"
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
        end

        should "see an error message" do
          assert page.has_content? "We couldn't find a council for this postcode."
        end

        should "populate google analytics tags" do
          track_action = page.find(".gem-c-error-summary")["data-track-action"]
          track_label = page.find(".gem-c-error-summary")["data-track-label"]

          assert_equal "postcodeErrorShown: noLaMatch", track_action
          assert_equal "We couldn't find a council for this postcode.", track_label
        end
      end
    end
  end

  context "when entering a specific local authority slug in the URL" do
    context "with valid slug" do
      setup do
        stub_local_links_manager_has_a_local_authority("islington")
        visit "/find-local-council/islington"
      end

      should "show the local authority result" do
        assert page.has_content?("Your local authority is")

        within(".unitary-result") do
          assert page.has_content?("Islington")
          assert page.has_link?("Go to Islington website", href: "http://islington.example.com", exact: true)
        end
      end
    end

    context "with invalid slug" do
      setup do
        stub_local_links_manager_does_not_have_an_authority("hogwarts")
        visit "/find-local-council/hogwarts"
      end

      should "see an error message" do
        assert_equal page.status_code, 404
      end
    end
  end
end
