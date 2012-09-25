require 'integration_test_helper'

class LicenceLookupTest < ActionDispatch::IntegrationTest

  context "given a licence which exists in licensify" do

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

      @artefact = {
        "title" => "Licence to Kill",
        "kind" => "licence",
        "details" => {
          "format" => "licence",
          "licence" => {
            "location_specific" => true,
            "availability" => ["England","Wales"],
            "authorities" => [{
              "name" => "Westminster City Council",
              "slug" => "westminster",
              "contact" => {
                "website" => "http://westminster.gov.uk/",
                "email" => "blah@westminster.gov.uk",
                "phone" => "02012345678",
                "address" => "Westminster City Hall, 64 Victoria Street"
              },
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
                ]
              }
            }]
          }
        },
        "tags" => [],
        "related" => []
      }

      content_api_has_an_artefact('licence-to-kill', @artefact)
      content_api_has_an_artefact_with_snac_code('licence-to-kill', '00BK', @artefact)
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

      should "display the authority name" do
        assert page.has_content?("Westminster")
      end

      should "show licence actions for apply, renew and change" do
        within("#content nav") do
          assert page.has_link? "How to apply", :href => '/licence-to-kill/westminster/apply'
          assert page.has_link? "How to renew", :href => '/licence-to-kill/westminster/renew'
          assert page.has_link? "How to change", :href => '/licence-to-kill/westminster/change'
        end
      end

      context "when visiting a licence action" do
        setup do
          click_link "How to apply"
        end

        should "display the page content" do
          assert page.has_content? "Licence to kill"
          assert page.has_selector? "h1", :text => "How to apply"
        end

        should "display a button to apply for the licence" do
          assert page.has_link? "Apply online", :href => "/licence-to-kill/westminster/apply-1"
        end
      end

      context "when visiting an action for which there are no links" do
        setup do
          click_link "How to change"
        end

        should "display contact details for the local authority" do
          # assert page.has_content? "contact your local authority"
          assert page.has_content? "Westminster City Hall"
        end
      end

      should "return a 404 for an invalid action" do
        visit "/licence-to-kill/westminster/blah"

        assert_equal 404, page.status_code
      end

      should "return a 404 for an invalid authority" do
        visit "/licence-to-kill/not-a-valid-council-name"

        assert_equal 404, page.status_code
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

  context "given a licence which does not exist in licensify" do
    setup do
      setup_api_responses("licence-to-kill")
      content_api_has_an_artefact("licence-to-kill", {
        "title" => "Licence to Kill",
        "kind" => "licence",
        "details" => {
          "format" => "licence",
          "licence" => {}
        },
        "tags" => [],
        "related" => []
      })
    end

    should "show message to contact local authority" do
      visit '/licence-to-kill'

      assert page.has_content?('contact your your local authority')
    end
  end

  context "given a non-location-specific licence which exists in licensify with multiple authorities" do
    setup do
      setup_api_responses('licence-to-turn-off-a-telescreen')
      content_api_has_an_artefact('licence-to-turn-off-a-telescreen', {
        "title" => "Licence to turn off a telescreen",
        "kind" => "licence",
        "details" => {
          "format" => "licence",
          "licence" => {
            "location_specific" => false,
            "availability" => ["England","Wales"],
            "authorities" => [{
              "name" => "Ministry of Plenty",
              "slug" => "miniplenty",
              "actions" => {
                "apply" => [{
                  "url" => "/licence-to-turn-off-a-telescreen/minsitry-of-plenty/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => ""
                }]
              }
            }, {
              "name" => "Ministry of Love",
              "slug" => "miniluv",
              "actions" => {
                "apply" => [{
                  "url" => "/licence-to-turn-off-a-telescreen/minsitry-of-love/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => ""
                }]
              }
            }, {
              "name" => "Ministry of Truth",
              "slug" => "minitrue",
              "actions" => {
                "apply" => [{
                  "url" => "/licence-to-turn-off-a-telescreen/minsitry-of-truth/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => ""
                }]
              }
            }, {
              "name" => "Ministry of Peace",
              "slug" => "minipax",
              "actions" => {
                "apply" => [{
                  "url" => "/licence-to-turn-off-a-telescreen/minsitry-of-peace/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => ""
                }]
              }
            }]
          }
        },
        "tags" => [],
        "related" => []
      })
    end

    context "when visiting the licence without specifying an authority" do
      setup do
        visit '/licence-to-turn-off-a-telescreen'
      end

      should "display the title" do
        assert page.has_content?('Licence to turn off a telescreen')
      end

      should "see the available authorities in a list" do
        assert page.has_content?('Ministry of Peace')
        assert page.has_content?('Ministry of Love')
        assert page.has_content?('Ministry of Truth')
        assert page.has_content?('Ministry of Plenty')
      end

      context "when selecting an authority" do
        setup do
          choose 'Ministry of Love'
          click_button "Select"
        end

        should "redirect to the authority slug" do
          assert_equal "/licence-to-turn-off-a-telescreen/miniluv", current_path
        end
      end
    end
  end

  context "given a non-location-specific licence which exists in licensify with a single authority" do
    setup do
      setup_api_responses('licence-to-turn-off-a-telescreen')
      content_api_has_an_artefact('licence-to-turn-off-a-telescreen', {
        "title" => "Licence to turn off a telescreen",
        "kind" => "licence",
        "details" => {
          "format" => "licence",
          "licence" => {
            "location_specific" => false,
            "availability" => ["England","Wales"],
            "authorities" => [{
              "name" => "Ministry of Love",
              "slug" => "miniluv",
              "actions" => {
                "apply" => [{
                  "url" => "/licence-to-turn-off-a-telescreen/minsitry-of-love/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => ""
                }]
              }
            }]
          }
        },
        "tags" => [],
        "related" => []
      })
    end

    context "when visiting the licence" do
      setup do
        visit '/licence-to-turn-off-a-telescreen'
      end

      should "display the title" do
        assert page.has_content?('Licence to turn off a telescreen')
      end

      should "show licence actions for the single authority" do
        within("#content nav") do
          assert page.has_link? "How to apply", :href => '/licence-to-turn-off-a-telescreen/miniluv/apply'
        end
      end
    end
  end

  context "given a location-specific licence which does not exist in licensify for an authority" do
    setup do
      setup_api_responses("licence-to-kill")
      content_api_has_an_artefact_with_snac_code("licence-to-kill", "30UN", {
        "title" => "Licence to Kill",
        "kind" => "licence",
        "details" => {
          "format" => "licence"
        },
        "tags" => [],
        "related" => []
      })
    end

    should "show message to contact local authority" do
      visit '/licence-to-kill/south-ribble'
      save_page

      assert page.status_code == 200
      assert page.has_content?('contact your your local authority')
    end
  end

  context "given a licence edition with alternative licence information fields" do
    setup do
      setup_api_responses("artistic-license")
      content_api_has_an_artefact('artistic-license', {
        "title" => "Artistic License",
        "kind" => "licence",
        "details" => {
          "format" => "licence",
          "licence" => nil
        },
        "tags" => [],
        "related" => []
      })
    end

    context "when visiting the licence" do
      setup do
        visit '/artistic-license'
      end

      should "not see a location form" do
        assert ! page.has_field?('postcode')
      end

      should "see a 'Get Started' button" do
        assert page.has_content?('Get started')
      end
    end
  end

end
