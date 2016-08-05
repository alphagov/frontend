require 'integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/local_links_manager'

class LocalCouncilTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::LocalLinksManager

  context "when visiting the start page" do
    should "show Find Local Council start page" do
      visit '/find-your-local-council'

      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
      assert page.has_field?("postcode")
    end

    should "show the breadcrumbs" do
      within('#global-breadcrumb') do
        assert page.has_link?("Home", href: "/", exact: true)
        assert page.has_link?("Housing and local services", href: "https://www.gov.uk/browse/housing-local-services", exact: true)
        assert page.has_link?("Local councils and services", href: "https://www.gov.uk/browse/housing-local-services/local-councils", exact: true)
      end
    end

    should "show the related links" do
      visit '/find-your-local-council'

      # related links are tested like this in the rest of frontend
      assert page.has_selector?("#test-related")
    end
  end

  context "when visiting the find local council start page with valid postcode" do
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

        visit '/find-your-local-council'
        fill_in 'postcode', with: "SW1A 1AA"
        click_button('Find')
      end

      should "redirect to the authority slug" do
        assert_equal "/find-your-local-council/westminster", current_path
      end

      should "show the local authority result" do
        assert page.has_content?("Your postcode is in:")

        within('.unitary-result') do
          assert page.has_content?("Westminster")
          assert page.has_link?("westminster.example.com", href: "http://westminster.example.com", exact: true)
        end
      end

      should "show back link" do
        assert page.has_link?("Back", href: "/find-your-local-council")
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

        visit '/find-your-local-council'
        fill_in 'postcode', with: "HP20 1UG"
        click_button('Find')
      end

      should "redirect to the district authority slug" do
        assert_equal "/find-your-local-council/aylesbury", current_path
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

      should "show back link" do
        assert page.has_link?("Back", href: "/find-your-local-council")
      end
    end
  end

  context "when visiting the find local council start page with invalid postcode" do
    setup do
      mapit_does_not_have_a_bad_postcode("NO POSTCODE")

      visit '/find-your-local-council'
      fill_in 'postcode', with: "NO POSTCODE"
      click_button('Find')
    end

    should "remain on the find your local council page" do
      assert_equal "/find-your-local-council", current_path

      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
    end

    should "see an error message" do
      assert page.has_content? "This isn't a valid postcode"
    end

    should "re-populate the invalid input" do
      assert page.has_field? "postcode", with: "NO POSTCODE"
    end
  end

  context "when visiting the find local council start page with a blank postcode" do
    setup do
      visit '/find-your-local-council'
      fill_in 'postcode', with: ""
      click_button('Find')
    end

    should "remain on the find your local council page" do
      assert_equal "/find-your-local-council", current_path

      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
    end

    should "see an error message" do
      assert page.has_content? "This isn't a valid postcode"
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

      visit '/find-your-local-council'
      fill_in 'postcode', with: "SW1A 1AA"
      click_button('Find')
    end

    should "show advisory message that we have no URL" do
      assert page.has_content? "We don't have a link for their website."
    end
  end

  context "when no local council is found for a valid postcode" do
    setup do
      mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], [
        {
          "ons" => "00BK",
          "govuk_slug" => "",
          "name" => "Christmas HQ",
          "type" => "DIS"
        },
      ])

      visit '/find-your-local-council'
      fill_in 'postcode', with: "XM4 5HQ"
      click_button('Find')
    end

    should "remain on the find your local council page" do
      assert_equal "/find-your-local-council", current_path

      assert page.has_content?("Find your local council")
      assert page.has_content?("Find the website for your local council.")
    end

    should "see an error message" do
      assert page.has_content? "We couldn't find a council for this postcode."
    end
  end

  context "when entering a specific local authority slug in the url" do
    context "with valid slug" do
      setup do
        local_links_manager_has_a_local_authority('islington')
        visit '/find-your-local-council/islington'
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
        visit '/find-your-local-council/hogwarts'
      end

      should "see an error message" do
        assert_equal page.status_code, 404
      end
    end
  end

  context "when no Mapit area is found for a postcode" do
    setup do
      mapit_has_a_postcode_and_areas("XM4 5HQ", [0.00, -0.00], {})

      visit '/find-your-local-council'
      fill_in 'postcode', with: "XM4 5HQ"
      click_button('Find')
    end

    should "see an error message" do
      assert page.has_content? "We couldn't find a council for this postcode."
    end

    should "re-populate the invalid input" do
      assert page.has_field? "postcode", with: "XM4 5HQ"
    end
  end
end
