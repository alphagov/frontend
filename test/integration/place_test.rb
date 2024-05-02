require "integration_test_helper"
require "gds_api/test_helpers/places_manager"

class PlacesTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::PlacesManager

  setup do
    @payload = {
      title: "Find a passport interview office",
      base_path: "/passport-interview-office",
      schema_name: "place",
      document_type: "place",
      phase: "beta",
      public_updated_at: "2012-10-02T15:21:03+00:00",
      details: {
        introduction: "<p>Enter your postcode to find a passport interview office near you.</p>",
        more_information: "Some more info on passport offices",
        need_to_know: "<ul><li>Proof of identification required</li></ul>",
        place_type: "find-passport-offices",
      },
      external_related_links: [],
    }

    stub_content_store_has_item("/passport-interview-office", @payload)

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
          "latitude" => 51.49338734529598,
        },
        "name" => "London IPS Office",
        "phone" => "0800 123 4567",
        "postcode" => "SW1V 1PN",
        "text_phone" => nil,
        "town" => "London",
        "url" => "http://www.example.com/london_ips_office",
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
          "latitude" => 51.112777245292826,
        },
        "name" => "Crawley IPS Office",
        "phone" => nil,
        "postcode" => "RH10 1HU",
        "text_phone" => nil,
        "town" => "Crawley",
        "url" => nil,
      },
    ]
  end

  context "when visiting the start page" do
    setup do
      visit "/passport-interview-office"
    end

    should "render the place page" do
      assert_equal 200, page.status_code

      within "head", visible: :all do
        assert page.has_selector?("title", text: "Find a passport interview office - GOV.UK", visible: :all)
      end

      within "#content" do
        within ".gem-c-title" do
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
      end

      assert page.has_selector?(".gem-c-phase-banner")
    end

    should "add google analytics tags for postcodeSearchStarted" do
      track_category = page.find(".postcode-search-form")["data-track-category"]
      track_action = page.find(".postcode-search-form")["data-track-action"]

      assert_equal "postcodeSearch:place", track_category
      assert_equal "postcodeSearchStarted", track_action
    end

    should "add GA4 form submit attributes" do
      data_module = page.find("form")["data-module"]
      expected_data_module = "ga4-form-tracker"

      ga4_form_attribute = page.find("form")["data-ga4-form"]
      ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"place\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find a passport interview office\"}"

      assert_equal expected_data_module, data_module
      assert_equal ga4_expected_object, ga4_form_attribute
    end
  end

  context "given a valid postcode" do
    setup do
      stub_plcaes_manager_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::IMMINENCE_QUERY_LIMIT, nil)

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
      names = page.all("#options li .adr h3.fn").map(&:text)
      assert_equal ["London IPS Office", "Crawley IPS Office"], names

      within "#options > li:first-child" do
        assert page.has_content?("89 Eccleston Square")
        assert page.has_content?("London")
        assert page.has_content?("SW1V 1PN")

        assert page.has_link?("http://www.example.com/london_ips_office", href: "http://www.example.com/london_ips_office")
        assert page.has_content?("Phone: 0800 123 4567")

        assert page.has_content?("Monday to Saturday 8.00am - 6.00pm.")
        assert page.has_content?("The London Passport Office is fully accessible to wheelchair users.")
      end
    end

    should "format general notes and access notes" do
      within "#options > li:nth-child(2)" do
        assert page.has_content?("Station Way")

        assert page.has_selector?("p", text: "Monday to Saturday 8.00am - 6.00pm.")
        assert page.has_selector?("p", text: "Sunday 1pm - 2pm.")
        assert page.has_selector?("p", text: "The doors are always locked.")
        assert page.has_selector?("p", text: "And they are at the top of large staircases.")
      end
    end

    should "add google analytics for postcodeResultsShown" do
      track_category = page.find(".places-results")["data-track-category"]
      track_action = page.find(".places-results")["data-track-action"]
      track_label = page.find(".places-results")["data-track-label"]

      assert_equal "postcodeSearch:place", track_category
      assert_equal "postcodeResultShown", track_action
      assert_equal "London IPS Office", track_label
    end

    should "add GA4 form_complete attributes" do
      data_module = page.find(".places-results")["data-module"]
      expected_data_module = "auto-track-event ga4-auto-tracker ga4-link-tracker"

      ga4_auto_attribute = page.find(".places-results")["data-ga4-auto"]
      ga4_expected_object = "{\"event_name\":\"form_complete\",\"action\":\"complete\",\"type\":\"place\",\"text\":\"Results near [postcode]\",\"tool_name\":\"Find a passport interview office\"}"

      assert_equal expected_data_module, data_module
      assert_equal ga4_expected_object, ga4_auto_attribute
    end

    should "add GA4 information click attributes" do
      data_module = page.find(".places-results")["data-module"]
      expected_data_module = "auto-track-event ga4-auto-tracker ga4-link-tracker"

      assert page.has_selector?("[data-ga4-set-indexes]")
      assert page.has_selector?("[data-ga4-track-links-only]")

      ga4_auto_attribute = page.find(".places-results")["data-ga4-link"]
      ga4_expected_object = "{\"event_name\":\"information_click\",\"action\":\"information click\",\"type\":\"place\",\"tool_name\":\"Find a passport interview office\"}"

      assert_equal expected_data_module, data_module
      assert_equal ga4_expected_object, ga4_auto_attribute
    end
  end

  context "given a valid postcode with no nearby places" do
    setup do
      @places = []

      stub_plcaes_manager_has_places_for_postcode(@places, "find-passport-offices", "SW1A 1AA", Frontend::IMMINENCE_QUERY_LIMIT, nil)

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
      track_category = page.find(".gem-c-error-summary")["data-track-category"]
      track_action = page.find(".gem-c-error-summary")["data-track-action"]
      track_label = page.find(".gem-c-error-summary")["data-track-label"]

      assert_equal "userAlerts: place", track_category
      assert_equal "postcodeErrorShown: validPostcodeNoLocation", track_action
      assert_equal "We couldn't find any results for this postcode.", track_label
    end
  end

  context "given an empty postcode" do
    setup do
      visit "/passport-interview-office"
      click_on "Find"
    end

    should "display error message" do
      assert page.has_content?("This isn't a valid postcode")
    end

    should "include GA4 form error attributes" do
      data_module = page.find("#results")["data-module"]
      expected_data_module = "auto-track-event ga4-auto-tracker govuk-error-summary"

      ga4_error_attribute = page.find("#results")["data-ga4-auto"]
      ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"place\",\"text\":\"This isn't a valid postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Find a passport interview office\"}"

      assert_equal expected_data_module, data_module
      assert_equal ga4_expected_object, ga4_error_attribute
    end

    should "display the postcode form" do
      within ".location-form" do
        assert page.has_field?("Enter a postcode")
        assert page.has_field?("postcode")
        assert_has_button("Find")
      end
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
      within ".location-form" do
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

  context "given a postcode which covers multiple authorities (and a local_authority place)" do
    setup do
      addresses = [
        { "address" => "House 1", "local_authority_slug" => "achester" },
        { "address" => "House 2", "local_authority_slug" => "beechester" },
        { "address" => "House 3", "local_authority_slug" => "ceechester" },
      ]

      stub_imminence_has_multiple_authorities_for_postcode(addresses, "find-passport-offices", "CH25 9BJ", Frontend::IMMINENCE_QUERY_LIMIT)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "CH25 9BJ"
      click_on "Find"
    end

    should "display the address chooser" do
      assert page.has_content?("House 1")
    end
  end

  context "given an internal error response from imminence" do
    setup do
      query_hash = { "postcode" => "JE4 5TP", "limit" => Frontend::IMMINENCE_QUERY_LIMIT }
      stub_imminence_places_request("find-passport-offices", query_hash, {}, 500)

      visit "/passport-interview-office"
      fill_in "Enter a postcode", with: "JE4 5TP"
      click_on "Find"
    end

    should "reraise as a 503" do
      assert_equal 503, page.status_code
    end
  end
end
