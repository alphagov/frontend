require_relative '../integration_test_helper'

class PlacesTest < ActionDispatch::IntegrationTest

  setup do
    stub_location_request("SW1A 1AA", {
      "wgs84_lat" => 51.5010096,
      "wgs84_lon" => -0.1415871,
      "areas" => {
        1 => {"id" => 1, "codes" => {"ons" => "00BK"}, "name" => "Westminster City Council", "type" => "LBO" },
        2 => {"id" => 2, "codes" => {"unit_id" => "41441"}, "name" => "Greater London Authority", "type" => "GLA" }
      },
      "shortcuts" => {
        "council" => 1
      }
    })

    @artefact = artefact_for_slug('passport-interview-office').merge({
      "title" => "Find a passport interview office",
      "format" => "place",
      "details" => {
        "description" => "Find a passport interview office",
        "place_type" => "find-passport-offices",
        "expectations" => [ "Proof of identification required" ],
      },
    })
    content_api_has_an_artefact('passport-interview-office', @artefact)

    imminence_has_places("51.5010096", "-0.1415871", {
      "slug" => "find-passport-offices",
      "details" => [
        {
          "_id" => "5077eeb0e5274a7405000004",
          "access_notes" => "The London Passport Office is fully accessible to wheelchair users. ",
          "address1" => nil,
          "address2" => "89 Eccleston Square",
          "data_set_version" => 2,
          "email" => nil,
          "fax" => nil,
          "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
          "geocode_error" => nil,
          "location" => {
              "longitude" => -0.14411606838362725,
              "latitude" => 51.49338734529598
          },
          "name" => "London IPS Office",
          "phone" => "0800 123 4567",
          "postcode" => "SW1V 1PN",
          "service_slug" => "find-passport-offices",
          "source_address" => " 89 Eccleston Square, London SW1V 1PN",
          "text_phone" => nil,
          "town" => "London",
          "url" => "http://www.example.com/london_ips_office"
        },
        {
          "_id" => "5077eeb0e5274a7405000005",
          "access_notes" => nil,
          "address1" => nil,
          "address2" => "Station Way",
          "data_set_version" => 2,
          "email" => nil,
          "fax" => nil,
          "general_notes" => "Monday to Saturday 8.00am - 6.00pm. ",
          "geocode_error" => nil,
          "location" => {
              "longitude" => -0.18832238262617113,
              "latitude" => 51.112777245292826
          },
          "name" => "Crawley IPS Office",
          "phone" => nil,
          "postcode" => "RH10 1HU",
          "service_slug" => "find-passport-offices",
          "source_address" => " Station Way Crawley RH10 1HU",
          "text_phone" => nil,
          "town" => "Crawley",
          "url" => nil
        }
      ]
    })
  end

  should "display places near to the requested location" do

    visit "/passport-interview-office"
    fill_in "Enter a UK postcode", :with => "SW1A 1AA"
    click_on "Find"

    within '#options' do
      names = page.all("li p.adr span.fn").map(&:text)
      assert_equal ["London IPS Office", "Crawley IPS Office"], names

      within 'li:first-child' do
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
