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

    content_api_has_an_artefact_with_snac_code('licence-to-kill', '00BK', {
      "title" => "Licence to Kill",
      "format" => "licence",
      "details" => {
        "licence" => {
          "location_specific" => true,
          "availability" => ["England","Wales"],
          "authorities" => [{
            "name" => "Westminster City Council",
            "actions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/westminster/apply-1",
                  "description" => "Apply for your licence to kill",
                  "payment" => "none",
                  "introduction" => "This licence is issued shaken, not stirred."
                },{
                  "url" => "/licence-to-kill/westminster/apply-2",
                  "description" => "Apply for your licence to hold gadgets",
                  "payment" => "none",
                  "introduction" => "Q-approval required."
                }
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/westminster/renew-1",
                  "description" => "Renew your licence to kill",
                  "payment" => "none",
                  "introduction" => ""
                }
              ],
              "change" => [
                {
                  "url" => "/licence-to-kill/westminster/change-1",
                  "description" => "Transfer your licence to kill",
                  "payment" => "none",
                  "introduction" => ""
                }
              ]
            }
          }]
        }
      },
      "tags" => [],
      "related" => []
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
    setup do
      visit '/licence-to-kill'

      fill_in 'postcode', :with => "SW1A 1AA"
      click_button('Find')
    end

    should "redirect to the appropriate authority slug" do
      assert_equal "/licence-to-kill/westminster", current_path
    end

    should "show licence actions" do
      within("#content nav") do
        assert page.has_link? "Apply", :href => '/licence-to-kill/westminster/apply'
        assert page.has_link? "Renew", :href => '/licence-to-kill/westminster/renew'
        assert page.has_link? "Change", :href => '/licence-to-kill/westminster/change'
      end
    end

    context "when visiting a licence action" do
      setup do
        click_link "Apply"
      end

      should "display the page content" do
        assert page.has_content? "Licence to kill"
        assert page.has_selector? "h1", :text => "Apply"
      end
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
