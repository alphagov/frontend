require_relative '../integration_test_helper'
require 'gds_api/test_helpers/mapit'
require 'gds_api/test_helpers/imminence'

class PlacesTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::Mapit

  setup do
    mapit_has_a_postcode("SW1A 1AA", [51.5010096, -0.1415871])

    @artefact = artefact_for_slug('passport-interview-office').merge({
      "title" => "Find a passport interview office",
      "format" => "place",
      "in_beta" => true,
      "details" => {
        "description" => "Find a passport interview office",
        "place_type" => "find-passport-offices",
        "expectations" => [ "Proof of identification required" ],
        "introduction" =>  "<p>Enter your postcode to find a passport interview office near you.</p>"
      }
    })
    content_api_has_an_artefact('passport-interview-office', @artefact)

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
        "access_notes" => nil,
        "address1" => nil,
        "address2" => "Station Way",
        "email" => nil,
        "fax" => nil,
        "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
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

  should "show the postcode form and introduction without a postcode" do
    visit '/passport-interview-office'

    within ".page-header" do
      assert page.has_content?("Find a passport interview office")
    end

    within '.beta-label' do
      assert page.has_link?("find out what this means", :href => "/help/beta")
    end

    within ".intro" do
      assert page.has_content?("Enter your postcode to find a passport interview office near you.")
    end

    within ".find-location-for-service" do
      assert page.has_field?("Enter a UK postcode")
      assert page.has_button?("Find")
    end

    within ".further_information" do
      assert page.has_content?("Further information")

      within "ul" do
        assert page.has_selector?("li", :text => "Proof of identification required")
      end
    end

    assert page.has_no_content?("Please enter a valid full UK postcode.")
  end

  context "given a valid postcode" do
    setup do
      stub_request(:get, GdsApi::TestHelpers::Imminence::IMMINENCE_API_ENDPOINT + "/places/find-passport-offices.json?limit=5&postcode=SW1A%201AA").
        to_return(:body => @places.to_json, :status => 200)

      visit "/passport-interview-office"
      fill_in "Enter a UK postcode", :with => "SW1A 1AA"
      click_on "Find"
    end

    should "not display an error message" do
      assert page.has_no_content?("Please enter a valid full UK postcode.")
    end

    should "not show the 'no results' message" do
      assert page.has_no_content?("Sorry, no results were found near you.")
    end

    should "display places near to the requested location" do
      within '#options' do
        names = page.all("li p.adr span.fn").map(&:text)
        assert_equal ["London IPS Office", "Crawley IPS Office"], names

        within first('li:first-child') do
          assert page.has_content?("89 Eccleston Square")
          assert page.has_content?("London")
          assert page.has_content?("SW1V 1PN")

          assert page.has_link?("http://www.example.com/london_ips...", :href => "http://www.example.com/london_ips_office")
          assert page.has_content?("Phone: 0800 123 4567")

          assert page.has_content?("Monday to Saturday 8.00am - 6.00pm.")
          assert page.has_content?("The London Passport Office is fully accessible to wheelchair users.")
        end
      end
    end
  end

  context "given a valid postcode with no nearby places" do
    setup do
      @places = []

      stub_request(:get, GdsApi::TestHelpers::Imminence::IMMINENCE_API_ENDPOINT + "/places/find-passport-offices.json?limit=5&postcode=SW1A%201AA").
        to_return(:body => @places.to_json, :status => 200)

      visit "/passport-interview-office"
      fill_in "Enter a UK postcode", :with => "SW1A 1AA"
      click_on "Find"
    end

    should "not error on a bad postcode" do
      assert page.has_no_content?("Please enter a valid full UK postcode.")
    end

    should "inform the user on the lack of results" do
      assert page.has_content?("Sorry, no results were found near you.")
    end
  end

  context "given an invalid postcode" do
    setup do
      stub_request(:get, GdsApi::TestHelpers::Imminence::IMMINENCE_API_ENDPOINT + "/places/find-passport-offices.json?limit=5&postcode=SW1A%202AA").
        to_return(:status => 400)

      visit "/passport-interview-office"
      fill_in "Enter a UK postcode", :with => "SW1A 2AA"
      click_on "Find"
    end

    should "display error message" do
      assert page.has_content?("Please enter a valid full UK postcode.")
    end

    should "not show the 'no results' message" do
      assert page.has_no_content?("Sorry, no results were found near you.")
    end

    should "display the postcode form" do
      within ".find-location-for-service" do
        assert page.has_field?("Enter a UK postcode")
        assert page.has_button?("Find")
      end
    end
  end
end
