require 'integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/imminence'

class PlacesTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::Imminence

  setup do
    mapit_has_a_postcode("SW1A 1AA", [51.5010096, -0.1415871])

    @payload = {
      title: "Find a passport interview office",
      base_path: "/passport-interview-office",
      schema_name: "place",
      document_type: 'place',
      phase: "beta",
      public_updated_at: "2012-10-02T15:21:03+00:00",
      details: {
        introduction: "<p>Enter your postcode to find a passport interview office near you.</p>",
        more_information: "Some more info on passport offices",
        need_to_know: "<ul><li>Proof of identification required</li></ul>",
        place_type: "find-passport-offices"
      },
      external_related_links: []
    }

    content_store_has_item('/passport-interview-office', @payload)

    @places = [
      {
        "access_notes" => "The London Passport Office is fully accessible to wheelchair users. ",
        "address1" => nil,
        "address2" => "89 Eccleston Square",
        "email" => nil,
        "fax" => nil,
        "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
        "location" => {
            "longitude" => -0.14411606838362725,
            "latitude" => 51.49338734529598
        },
        "name" => "London IPS Office",
        "phone" => "0800 123 4567",
        "postcode" => "SW1V 1PN",
        "text_phone" => nil,
        "town" => "London",
        "url" => "http://www.example.com/london_ips_office"
      },
      {
        "access_notes" => "The doors are always locked.\n\nAnd they are at the top of large staircases.",
        "address1" => nil,
        "address2" => "Station Way",
        "email" => nil,
        "fax" => nil,
        "general_notes" => "Monday to Saturday 8.00am - 6.00pm.\n\nSunday 1pm - 2pm.",
        "location" => {
            "longitude" => -0.18832238262617113,
            "latitude" => 51.112777245292826
        },
        "name" => "Crawley IPS Office",
        "phone" => nil,
        "postcode" => "RH10 1HU",
        "text_phone" => nil,
        "town" => "Crawley",
        "url" => nil
      }
    ]
  end

  context "when visiting the start page" do
    setup do
      visit '/passport-interview-office'
    end

    should "render the place page" do
      assert_equal 200, page.status_code

      within 'head', visible: :all do
        assert page.has_selector?("title", text: "Find a passport interview office - GOV.UK", visible: :all)
      end

      within '#content' do
        within ".page-header" do
          assert_has_component_title "Find a passport interview office"
        end

        assert page.has_content?("Enter your postcode to find a passport interview office near you.")
        assert page.has_field?("Enter a postcode")
        assert_has_button("Find")
        assert page.has_no_content?("Please enter a valid full UK postcode.")

        within ".further-information" do
          assert page.has_content?("Further information")

          within "ul" do
            assert page.has_selector?("li", text: "Proof of identification required")
          end
        end

        within '.article-container' do
          assert page.has_selector?(".gem-c-phase-banner")
        end
      end
    end

    should "add google analytics tags for postcodeSearchStarted" do
      track_category = page.find('.postcode-search-form')['data-track-category']
      track_action = page.find('.postcode-search-form')['data-track-action']

      assert_equal "postcodeSearch:place", track_category
      assert_equal "postcodeSearchStarted", track_action
    end
  end

  context "given a valid postcode" do
    setup do
      imminence_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::IMMINENCE_QUERY_LIMIT)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "SW1A 1AA"
      click_on "Find"
    end

    should "redirect to same page and not put postcode as URL query parameter" do
      assert_current_url "/passport-interview-office"
    end

    should "not display an error message" do
      assert page.has_no_content?("Please enter a valid full UK postcode.")
    end

    should "not show the 'no results' message" do
      assert page.has_no_content?("We couldn't find any results for this postcode.")
    end

    should "display places near to the requested location" do
      names = page.all("#options li p.adr span.fn").map(&:text)
      assert_equal ["London IPS Office", "Crawley IPS Office"], names

      within '#options > li:first-child' do
        assert page.has_content?("89 Eccleston Square")
        assert page.has_content?("London")
        assert page.has_content?("SW1V 1PN")

        assert page.has_link?("http://www.example.com/london_ips_office", href: "http://www.example.com/london_ips_office")
        assert page.has_content?("Phone: 0800 123 4567")

        assert page.has_content?("Monday to Saturday 8.00am - 6.00pm.")
        assert page.has_content?("The London Passport Office is fully accessible to wheelchair users.")
      end
    end

    should 'format general notes and access notes' do
      within '#options > li:nth-child(2)' do
        assert page.has_content?("Station Way")

        assert page.has_selector?('p', text: "Monday to Saturday 8.00am - 6.00pm.")
        assert page.has_selector?('p', text: 'Sunday 1pm - 2pm.')
        assert page.has_selector?('p', text: "The doors are always locked.")
        assert page.has_selector?('p', text: "And they are at the top of large staircases.")
      end
    end

    should "add google analytics for postcodeResultsShown" do
      track_category = page.find('.places-results')['data-track-category']
      track_action = page.find('.places-results')['data-track-action']
      track_label = page.find('.places-results')['data-track-label']

      assert_equal "postcodeSearch:place", track_category
      assert_equal "postcodeResultShown", track_action
      assert_equal "London IPS Office", track_label
    end
  end

  context "given a valid postcode for report child abuse" do
    setup do
      mapit_has_a_postcode("N5 1QL", [51.5505284612, -0.100467152148])

      @payload_for_report_child_abuse = {
        title: "Find your local child social care team",
        base_path: "/report-child-abuse-to-local-council",
        schema_name: "place",
        document_type: 'place',
        in_beta: true,
        details: {
          description: "Find your local child social care team",
          place_type: "find-child-social-care-team",
          introduction: "<p>Contact your local council if you think a child is at risk</p>"
        }
      }

      content_store_has_item("/report-child-abuse-to-local-council", @payload_for_report_child_abuse)

      @places_for_report_child_abuse = [
        {
          "name" => "Islington",
          "phone" => "020 7226 1436 (Monday to Friday)",
          "general_notes" => "020 7226 0992 (out of hours)",
          "url" => "http://www.islington.gov.uk/services/children-families/cs-worried/Pages/default.aspx"
        }
      ]

      imminence_has_places_for_postcode(@places_for_report_child_abuse, "find-child-social-care-team", "N5 1QL", Frontend::IMMINENCE_QUERY_LIMIT)

      visit "/report-child-abuse-to-local-council"
      fill_in "Enter a postcode", with: "N5 1QL"
      click_on "Find"
    end

    should "not display an error message" do
      assert page.has_no_content?("Please enter a valid full UK postcode.")
    end

    should "not show the 'no results' message" do
      assert page.has_no_content?("We couldn't find any results for this postcode.")
    end

    should "display places near to the requested location" do
      within '#options' do
        names = page.all("li p.adr span.fn").map(&:text)
        assert_equal ["You can call the children's social care team at the council in Islington"], names

        within first('li:first-child') do
          assert page.has_link?("020 7226 1436", href: "tel://020%207226%201436")
          assert page.has_content?("(Monday to Friday)")
          assert page.has_link?("020 7226 0992", href: "tel://020%207226%200992")
          assert page.has_content?("(out of hours)")

          assert page.has_link?("Go to their website", href: "http://www.islington.gov.uk/services/children-families/cs-worried/Pages/default.aspx")
        end
      end
    end
  end

  context "given a valid postcode with no nearby places" do
    setup do
      @places = []

      imminence_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::IMMINENCE_QUERY_LIMIT)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "SW1A 1AA"
      click_on "Find"
    end

    should "not error on a bad postcode" do
      assert page.has_no_content?("Please enter a valid full UK postcode.")
    end

    should "inform the user on the lack of results" do
      assert page.has_content?("We couldn't find any results for this postcode.")
    end

    should "add google analytics for noResults" do
      track_category = page.find('.gem-c-error-alert')['data-track-category']
      track_action = page.find('.gem-c-error-alert')['data-track-action']
      track_label = page.find('.gem-c-error-alert')['data-track-label']

      assert_equal "userAlerts: place", track_category
      assert_equal "postcodeErrorShown: validPostcodeNoLocation", track_action
      assert_equal "We couldn't find any results for this postcode.", track_label
    end
  end

  context "given an invalid postcode" do
    setup do
      query_hash = { "postcode" => "BAD POSTCODE", "limit" => Frontend::IMMINENCE_QUERY_LIMIT }
      return_data = { "error" => "invalidPostcodeError" }
      stub_imminence_places_request("find-passport-offices", query_hash, return_data, 400)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "BAD POSTCODE"
      click_on "Find"
    end

    should "display error message" do
      assert page.has_content?("This isn't a valid postcode")
    end

    should "not show the 'no results' message" do
      assert page.has_no_content?("We couldn't find any results for this postcode.")
    end

    should "display the postcode form" do
      within ".ask_location" do
        assert page.has_field?("Enter a postcode")
        assert page.has_field? "postcode", with: "BAD POSTCODE"
        assert_has_button("Find")
      end
    end
  end

  context "given a valid postcode with no locations returned" do
    setup do
      query_hash = { "postcode" => "JE4 5TP", "limit" => Frontend::IMMINENCE_QUERY_LIMIT }
      return_data = { "error" => "validPostcodeNoLocation" }

      stub_imminence_places_request("find-passport-offices", query_hash, return_data, 400)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "JE4 5TP"
      click_on "Find"
    end

    should "display the 'no locations found' message" do
      assert page.has_content?("We couldn't find any results for this postcode.")
    end
  end

  context "when previously a format with parts" do
    should "reroute to the base slug if requested with part route" do
      visit "/passport-interview-office/old-part-route"
      assert_current_url "/passport-interview-office"
    end
  end
end
