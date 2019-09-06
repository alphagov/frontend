require 'integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/local_links_manager'

class FindLocalCouncilTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  setup do
    content_store_has_random_item(base_path: '/find-local-council')
  end

  context "when visiting the start page" do
    setup do
      Frontend.stubs(:govuk_website_root).returns("https://www.test.gov.uk")
      visit '/find-local-council'
    end

    should "show Find Local Council start page" do
      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
      assert page.has_field?("postcode")
    end

    should "add google analytics tags for postcodeSearchStarted" do
      track_category = page.find('.postcode-search-form')['data-track-category']
      track_action = page.find('.postcode-search-form')['data-track-action']

      assert_equal "postcodeSearch:find_local_council", track_category
      assert_equal "postcodeSearchStarted", track_action
    end

    should "add the description as meta tag for SEO purposes" do
      description = page.find('meta[name="description"]', visible: false)['content']
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
          mapit_has_a_postcode_and_areas("SW1A 1AA", [51.5010096, -0.1415870], [
            {
              "ons" => "00BK",
              "govuk_slug" => "westminster",
              "name" => "Westminster City Council",
              "type" => "LBO"
            },
          ])
          local_links_manager_has_a_local_authority('westminster')

          visit '/find-local-council'
          fill_in 'postcode', with: "SW1A 1AA"
          click_on 'Find'
        end

        should "redirect to the authority slug" do
          assert_equal "/find-local-council/westminster", current_path
        end

        should "show the local authority result" do
          assert page.has_content?("Your postcode is in:")

          within('.unitary-result') do
            assert page.has_content?("Westminster")
            assert page.has_link?("westminster.example.com", href: "http://westminster.example.com", exact: true)
          end
        end

        should "have the correct titles" do
          assert_has_component_title "Find your local council"
          assert_equal "Find your local council - GOV.UK", page.title
        end

        should "add google analytics for postcodeResultsShown" do
          track_category = page.find('.local-authority-results')['data-track-category']
          track_action = page.find('.local-authority-results')['data-track-action']
          track_label = page.find('.local-authority-results')['data-track-label']

          assert_equal "postcodeSearch:find_local_council", track_category
          assert_equal "postcodeResultShown", track_action
          assert_equal "1 Result", track_label
        end

        should "show back link" do
          assert page.has_link?("Back", href: "/find-local-council")
        end

        should "add google analytics for exit link tracking" do
          track_action = find_link('westminster.example.com')['data-track-action']
          assert_equal "unitaryLinkClicked", track_action
        end
      end

      context "for district local authority" do
        setup do
          mapit_has_a_postcode_and_areas("HP20 1UG", [51.5010096, -0.1415870], [
            {
              "ons" => "00BK",
              "govuk_slug" => "aylesbury",
              "name" => "Aylesbury District",
              "type" => "DIS"
            },
            {
              "ons" => "00",
              "govuk_slug" => "buckinghamshire",
              "name" => "Buckinghamshire County",
              "type" => "CTY"
            }
          ])

          local_links_manager_has_a_district_and_county_local_authority('aylesbury', 'buckinghamshire')

          visit '/find-local-council'
          fill_in 'postcode', with: "HP20 1UG"
          click_on 'Find'
        end

        should "redirect to the district authority slug" do
          assert_equal "/find-local-council/aylesbury", current_path
        end

        should "show the local authority results for both district and county" do
          assert page.has_content?("Your postcode is in a county council and a district council")

          assert page.has_selector? '.county-result'
          assert page.has_selector? '.district-result'

          within('.county-result') do
            assert page.has_content?("Buckinghamshire")
            assert page.has_content?("County councils are responsible for services like:")
            assert page.has_link?("buckinghamshire.example.com", href: "http://buckinghamshire.example.com")
          end

          within('.district-result') do
            assert page.has_content?("Aylesbury")
            assert page.has_content?("District councils are responsible for services like:")
            assert page.has_link?("aylesbury.example.com", href: "http://aylesbury.example.com", exact: true)
          end
        end

        should "add google analytics for postcodeResultsShown" do
          track_category = page.find('.local-authority-results')['data-track-category']
          track_action = page.find('.local-authority-results')['data-track-action']
          track_label = page.find('.local-authority-results')['data-track-label']

          assert_equal "postcodeSearch:find_local_council", track_category
          assert_equal "postcodeResultShown", track_action
          assert_equal "2 Results", track_label
        end

        should "show back link" do
          assert page.has_link?("Back", href: "/find-local-council")
        end

        should "add google analytics for exit link tracking" do
          district_track_action = find_link('aylesbury.example.com')['data-track-action']
          county_track_action = find_link('buckinghamshire.example.com')['data-track-action']

          assert_equal "districtLinkClicked", district_track_action
          assert_equal "countyLinkClicked", county_track_action
        end
      end

      context "when finding a local council without homepage" do
        setup do
          mapit_has_a_postcode_and_areas("SW1A 1AA", [51.5010096, -0.1415870], [
            {
              "ons" => "00BK",
              "govuk_slug" => "westminster",
              "name" => "Westminster City Council",
              "type" => "LBO"
            },
          ])
          local_links_manager_has_a_local_authority_without_homepage('westminster')

          visit '/find-local-council'
          fill_in 'postcode', with: "SW1A 1AA"
          click_on 'Find'
        end

        should "show advisory message that we have no URL" do
          assert page.has_content? "We don't have a link for their website."
        end
      end
    end

    context "for unsuccessful postcode lookup" do
      context "with invalid postcode" do
        setup do
          mapit_does_not_have_a_bad_postcode("NO POSTCODE")

          visit '/find-local-council'
          fill_in 'postcode', with: "NO POSTCODE"
          click_on 'Find'
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
        end

        should "see an error message" do
          assert page.has_content? "This isn't a valid postcode"
        end

        should "re-populate the invalid input" do
          assert page.has_field? "postcode", with: "NO POSTCODE"
        end

        should "populate google analytics tags" do
          track_action = page.find('.gem-c-error-alert')['data-track-action']
          track_label = page.find('.gem-c-error-alert')['data-track-label']

          assert_equal "postcodeErrorShown: invalidPostcodeFormat", track_action
          assert_equal "This isn't a valid postcode.", track_label
        end
      end

      context "with blank postcode" do
        setup do
          visit '/find-local-council'
          fill_in 'postcode', with: ""
          click_on 'Find'
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
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

      context "with a valid postcode that is not present in MapIt" do
        setup do
          mapit_does_not_have_a_postcode("AB1 2AB")

          visit '/find-local-council'
          fill_in 'postcode', with: "AB1 2AB"
          click_on 'Find'
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
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

      context "with a valid postcode that has no areas in MapIt" do
        setup do
          mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], {})

          visit '/find-local-council'
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

      context "when no local council is found" do
        setup do
          mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], [
            {
              "ons" => "00BK",
              "govuk_slug" => "",
              "name" => "Christmas HQ",
              "type" => "DIS"
            },
          ])

          visit '/find-local-council'
          fill_in 'postcode', with: "XM4 5HQ"
          click_on 'Find'
        end

        should "remain on the find your local council page" do
          assert_equal "/find-local-council", current_path

          assert page.has_content?("Find your local council")
          assert page.has_content?("Find the website for your local council.")
        end

        should "see an error message" do
          assert page.has_content? "We couldn't find a council for this postcode."
        end

        should "populate google analytics tags" do
          track_action = page.find('.gem-c-error-alert')['data-track-action']
          track_label = page.find('.gem-c-error-alert')['data-track-label']

          assert_equal "postcodeErrorShown: noLaMatch", track_action
          assert_equal "We couldn't find a council for this postcode.", track_label
        end
      end
    end
  end

  context "when entering a specific local authority slug in the URL" do
    context "with valid slug" do
      setup do
        local_links_manager_has_a_local_authority('islington')
        visit '/find-local-council/islington'
      end

      should "show the local authority result" do
        assert page.has_content?("Your postcode is in:")

        within('.unitary-result') do
          assert page.has_content?("Islington")
          assert page.has_link?("islington.example.com", href: "http://islington.example.com", exact: true)
        end
      end
    end

    context "with invalid slug" do
      setup do
        local_links_manager_does_not_have_an_authority('hogwarts')
        visit '/find-local-council/hogwarts'
      end

      should "see an error message" do
        assert_equal page.status_code, 404
      end
    end
  end
end
