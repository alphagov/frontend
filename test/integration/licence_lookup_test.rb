require 'integration_test_helper'

class LicenceLookupTest < ActionDispatch::IntegrationTest

  setup do
    setup_api_responses("licence-to-kill")
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
  end

  context "when visiting the licence without specifying a location" do
    should "display the page content" do
      visit '/licence-to-kill'

      assert page.has_content? "Licence to kill"
      assert page.has_content? "You only live twice, Mr Bond."
    end
  end

  context "when visiting the licence with a postcode" do
    should "redirect to the appropriate authority slug" do
      visit '/licence-to-kill'

      fill_in 'postcode', :with => "SW1A 1AA"
      click_button('Find')

      assert_equal "/licence-to-kill/westminster", current_path
    end
  end

  context "when visiting the licence with an invalid postcode" do
    should "remain on the licence page" do
      visit '/licence-to-kill'

      fill_in 'postcode', :with => "Not a postcode"
      click_button('Find')

      assert_equal "/licence-to-kill", current_path
    end
  end

end
