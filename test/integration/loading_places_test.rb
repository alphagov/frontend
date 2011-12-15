# encoding: utf-8
require 'integration_test_helper'
require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'
require 'gds_api/test_helpers/imminence'
require 'slimmer/test'

class LoadingPlacesTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include GdsApi::TestHelpers::Publisher
  include GdsApi::TestHelpers::Panopticon
  include GdsApi::TestHelpers::Imminence

  def fake_gazeteer_response
<<-eos
{"place": ["Waterloo Sta, Lambeth", "470"], "postcode": ["SE1 7DB", "0"], "road": ["Newnham Terrace, Bishop's, London", "47"]}
eos
  end

  def fake_mapit_response
<<-eos
{"wgs84_lat": 51.498241853641055, "coordsyst": "G", "shortcuts": {"WMC": 65825, "ward": 8316, "council": 2490}, "wgs84_lon": -0.11354773400359928, "postcode": "SE1 7DU", "easting": 531044, "areas": {"900000": {"generation_high": 15, "codes": {}, "name": "House of Commons", "generation_low": 1, "country_name": "-", "country": "", "type_name": "UK Parliament", "type": "WMP", "id": 900000, "parent_area": null}, "34497": {"generation_high": 15, "codes": {"ons": "E02000618"}, "name": "Lambeth 001", "generation_low": 13, "country_name": "England", "country": "E", "type_name": "Middle Layer Super Output Area (Full)", "type": "OMF", "id": 34497, "parent_area": null}, "69154": {"generation_high": 15, "codes": {"ons": "E01003013"}, "name": "Lambeth 001B", "generation_low": 13, "country_name": "England", "country": "E", "type_name": "Lower Layer Super Output Area (Full)", "type": "OLF", "id": 69154, "parent_area": null}, "900006": {"generation_high": 15, "codes": {}, "name": "London Assembly", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "London Assembly area", "type": "LAS", "id": 900006, "parent_area": null}, "2247": {"generation_high": 15, "codes": {"unit_id": "41441"}, "name": "Greater London Authority", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "Greater London Authority", "type": "GLA", "id": 2247, "parent_area": null}, "103532": {"generation_high": 15, "codes": {"ons": "E01003013"}, "name": "Lambeth 001B", "generation_low": 13, "country_name": "England", "country": "E", "type_name": "Lower Layer Super Output Area (Generalised)", "type": "OLG", "id": 103532, "parent_area": null}, "65825": {"generation_high": 15, "codes": {"gss": "E14001008", "unit_id": "25036"}, "name": "Vauxhall", "generation_low": 13, "country_name": "England", "country": "E", "type_name": "UK Parliament constituency", "type": "WMC", "id": 65825, "parent_area": null}, "11822": {"generation_high": 15, "codes": {"gss": "E32000010", "unit_id": "41446"}, "name": "Lambeth and Southwark", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "London Assembly constituency", "type": "LAC", "id": 11822, "parent_area": 2247}, "900001": {"generation_high": 15, "codes": {}, "name": "European Parliament", "generation_low": 1, "country_name": "-", "country": "", "type_name": "European Parliament", "type": "EUP", "id": 900001, "parent_area": null}, "2490": {"generation_high": 15, "codes": {"ons": "00AY", "gss": "E09000022", "unit_id": "11144"}, "name": "Lambeth Borough Council", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "London borough", "type": "LBO", "id": 2490, "parent_area": null}, "41691": {"generation_high": 15, "codes": {"ons": "E02000618"}, "name": "Lambeth 001", "generation_low": 13, "country_name": "England", "country": "E", "type_name": "Middle Layer Super Output Area (Generalised)", "type": "OMG", "id": 41691, "parent_area": null}, "8316": {"generation_high": 15, "codes": {"ons": "00AYFZ", "gss": "E05000416", "unit_id": "11095"}, "name": "Bishop's", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "London borough ward", "type": "LBW", "id": 8316, "parent_area": 2490}, "11806": {"generation_high": 15, "codes": {"ons": "07", "gss": "E15000007", "unit_id": "41428"}, "name": "London", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "European region", "type": "EUR", "id": 11806, "parent_area": null}, "900002": {"generation_high": 15, "codes": {}, "name": "London Assembly", "generation_low": 1, "country_name": "England", "country": "E", "type_name": "London Assembly area (shared)", "type": "LAE", "id": 900002, "parent_area": 900006}}, "northing": 179387}
eos
  end

  def fake_other_mapit_response
<<-eos
{"wgs84_lat": 51.498665890246734, "coordsyst": "G", "wgs84_lon": -0.090415403925209165, "postcode": "SE1", "easting": 532648, "northing": 179476}
eos
  end

  def fake_slimmer_template
<<-eos
    <!DOCTYPE html>
    <html>
      <head>
        <title>Slimmer, yay!</title>
      </head>
      <body>
        <div class='content'>
          <header><h1>I AM A TITLE</h1></header>
          <div class='header-context'>
            <nav role='navigation'><ol><li>MySite</li></ol></nav>
          </div>
          <div id='wrapper' class='group'>
          </div>
        </div>
      </body>
    </html>
eos
  end

  setup do
    stub_request(:get, "http://assets.test.gov.uk/templates/wrapper.html.erb").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => fake_slimmer_template, :headers => {})
    stub_request(:get, "http://mapit.mysociety.org/postcode/SE1+7DU.json").
      to_return(:status => 200, :body => fake_mapit_response, :headers => {})
    stub_request(:get, "http://gazetteer.dracos.vm.bytemark.co.uk/point/51.498241853641055,-0.11354773400359928.json").
      to_return(:status => 200, :body => fake_mapit_response, :headers => {})
    stub_request(:get, "http://mapit.mysociety.org/postcode/partial/SE1.json").
      to_return(:status => 200, :body => fake_other_mapit_response, :headers => {})
    stub_request(:get, /.*\.js$/).to_return(:status => 200, :body => '')
  end

  test "Loading a place page" do
    publication_info = {
      "slug" => "register-offices",
      "updated_at" => "2011-09-13T15:51:12+00:00",
      "alternative_title" => "Local register offices",
      "introduction" => "Enter your postcode to find your local register office.",
      "more_information" => "Registrars deal with births, marriages, civil partnerships and death.",
      "overview" => "Find local register offices to register births, marriages and deaths",
      "place_type" => "registrars-offices",
      "title" => "Register offices ",
      "expectations" => [],
      "type" => "place"
    }
    artefact_info = {
      "slug" => "register-offices",
      "section" => "transport"
    }
    publication_exists(publication_info)
    panopticon_has_metadata(artefact_info)
    imminence_has_places("51.498665890246734", "-0.09041540392520916", {
      'slug' => 'registrars-offices',
      'details' => [
        {
          "_id" => "4e6e34d2e2ba802c7e000046",
          "access_notes" => nil,
          "address1" => "London",
          "address2" => nil,
          "fax" => nil,
          "general_notes" => nil,
          "geocode_error" => nil,
          "location" => [51.47323554537853, -0.08267075030697463],
          "name" => "34 Peckham Road",
          "phone" => nil,
          "postcode" => "SE5 8QA",
          "source_address" => "34 Peckham Road, London",
          "text_phone" => nil,
          "town" => nil,
          "url" => "http://www.southwark.gov.uk/YourServices/BirthsDeathsMarriages/"
        }
      ]
    })

    visit "/register-offices"
    fill_in 'postcode_box', :with => 'SE1 7DU'
    puts "Second request"
    click_on "Find my nearest →"
    assert page.has_content? "34 Peckham Road"
   end
end
