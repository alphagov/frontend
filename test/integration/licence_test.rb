require "integration_test_helper"
require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"
require "gds_api/test_helpers/licence_application"

class LicenceTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include GdsApi::TestHelpers::LicenceApplication
  include LocationHelpers

  context "given a location specific licence" do
    setup do
      configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
      stub_local_links_manager_does_not_have_an_authority("not-a-valid-council-name")

      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        phase: "beta",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          lgsl_code: 461,
          lgil_code: 8,
          licence_identifier: "1071-5-1",
          licence_overview: "You only live twice, Mr Bond.\n",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)

      stub_licence_exists(
        "1071-5-1",
        "isLocationSpecific" => true,
        "isOfferedByCounty" => false,
        "geographicalAvailability" => %w[England Wales],
        "issuingAuthorities" => [],
      )
    end

    context "when visiting the licence search page" do
      setup do
        visit "/licence-to-kill"
      end

      should "render the licence page" do
        assert_equal 200, page.status_code

        within "head", visible: :all do
          assert page.has_selector?("title", text: "Licence to kill - GOV.UK", visible: :all)
        end

        within "#content" do
          within ".gem-c-title" do
            assert_has_component_title "Licence to kill"
          end

          within ".postcode-search-form" do
            assert page.has_field?("Enter a postcode")
            assert_has_button("Find")
          end

          assert page.has_no_content?("Please enter a valid full UK postcode.")

          within "#overview" do
            assert page.has_content?("Overview")
            assert page.has_content? "You only live twice, Mr Bond."
          end
        end

        assert page.has_selector?(".gem-c-phase-banner")
      end

      should "add google analytics tags for postcodeSearchStarted" do
        track_category = page.find(".postcode-search-form")["data-track-category"]
        track_action = page.find(".postcode-search-form")["data-track-action"]

        assert_equal "postcodeSearch:licence", track_category
        assert_equal "postcodeSearchStarted", track_action
      end
    end

    context "when visiting the licence with a valid postcode" do
      context "when it's a unitary or district local authority" do
        setup do
          authorities = [
            {
              "authorityName" => "Westminster City Council",
              "authoritySlug" => "westminster",
              "authorityContact" => {
                "website" => "",
                "email" => "",
                "phone" => "020 7641 6000",
                "address" => "P.O. Box 240\nWestminster City Hall\n\n\nSW1E 6QP",
              },
              "authorityInteractions" => {
                "apply" => [
                  {
                    "url" => "/licence-to-kill/westminster/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                  {
                    "url" => "/licence-to-kill/westminster/apply-2",
                    "description" => "Apply for your licence to hold gadgets",
                    "payment" => "none",
                    "introduction" => "Q-approval required.",
                    "usesLicensify" => true,
                  },
                ],
                "renew" => [
                  {
                    "url" => "/licence-to-kill/westminster/renew-1",
                    "description" => "Renew your licence to kill",
                    "payment" => "none",
                    "introduction" => "",
                    "usesLicensify" => true,
                  },
                ],
              },
            },
          ]

          stub_licence_exists(
            "1071-5-1/00BK",
            "isLocationSpecific" => true,
            "isOfferedByCounty" => false,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => authorities,
          )
          visit "/licence-to-kill"

          fill_in "postcode", with: "SW1A 1AA"
          click_on "Find"
        end

        should "redirect to the appropriate authority slug" do
          assert_equal "/licence-to-kill/westminster", current_path
        end

        should "display the authority name" do
          within("#overview") do
            assert page.has_content?("Westminster")
          end
        end

        should "show available licence actions" do
          within("#content nav") do
            assert page.has_link? "How to apply", href: "/licence-to-kill/westminster/apply"
            assert page.has_link? "How to renew", href: "/licence-to-kill/westminster/renew"
          end
        end

        should "show overview section" do
          within("#overview") do
            assert page.has_content?("You only live twice, Mr Bond.")
          end
        end

        context "when visiting a licence action" do
          setup do
            click_link "How to apply"
          end

          should "display the page content" do
            assert page.has_content? "Licence to kill"
            assert page.has_selector? "h2", text: "How to apply"
          end

          should "display a button to apply for the licence" do
            assert_has_button_as_link(
              "Apply online",
              href: "/licence-to-kill/westminster/apply-1",
              start: true,
            )
          end
        end

        should "return a 404 for an invalid action" do
          visit "/licence-to-kill/westminster/blah"
          assert_equal 404, page.status_code

          visit "/licence-to-kill/westminster/change"
          assert_equal 404, page.status_code
        end

        should "return a 404 for an invalid authority" do
          visit "/licence-to-kill/not-a-valid-council-name"

          assert_equal 404, page.status_code
        end
      end

      context "when it's a county local authority" do
        setup do
          @payload = {
            base_path: "/licence-to-thrill",
            document_type: "licence",
            format: "licence",
            schema_name: "licence",
            title: "Licence to thrill",
            public_updated_at: "2012-10-02T12:30:33.483Z",
            description: "Descriptive licence text.",
            details: {
              lgsl_code: 461,
              lgil_code: 8,
              licence_identifier: "999",
              licence_overview: "You only live twice, Mr Bond.\n",
            },
          }

          stub_content_store_has_item("/licence-to-thrill", @payload)

          configure_locations_api_and_local_authority("HP20 2QF", %w[buckinghamshire], 440)

          authorities = [
            {
              "authorityName" => "Buckinghamshire Council",
              "authoritySlug" => "buckinghamshire",
              "authorityContact" => {
                "website" => "",
                "email" => "",
                "phone" => "",
                "address" => "",
              },
              "authorityInteractions" => {
                "apply" => [
                  {
                    "url" => "/licence-to-thrill/buckinghamshire/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                  {
                    "url" => "/licence-to-thrill/buckinghamshire/apply-2",
                    "description" => "Apply for your licence to hold gadgets",
                    "payment" => "none",
                    "introduction" => "Q-approval required.",
                    "usesLicensify" => true,
                  },
                ],
                "renew" => [
                  {
                    "url" => "/licence-to-thrill/buckinghamshire/renew-1",
                    "description" => "Renew your licence to kill",
                    "payment" => "none",
                    "introduction" => "",
                    "usesLicensify" => true,
                  },
                ],
              },
            },
          ]

          stub_licence_exists(
            "999/00BK",
            "isLocationSpecific" => true,
            "isOfferedByCounty" => true,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => authorities,
          )

          stub_licence_exists(
            "999",
            "isLocationSpecific" => true,
            "isOfferedByCounty" => true,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => [],
          )

          visit "/licence-to-thrill"

          fill_in "postcode", with: "HP20 2QF"
          click_on "Find"
        end

        should "redirect to the appropriate authority slug" do
          assert_equal "/licence-to-thrill/buckinghamshire", current_path
        end
      end

      context "when there are more than one authority" do
        setup do
          authorities = [
            {
              "authorityName" => "Westminster City Council",
              "authoritySlug" => "westminster",
              "authorityContact" => {
                "website" => "",
                "email" => "",
                "phone" => "020 7641 6000",
                "address" => "P.O. Box 240\nWestminster City Hall\n\n\nSW1E 6QP",
              },
              "authorityInteractions" => {
                "apply" => [
                  {
                    "url" => "/licence-to-kill/westminster/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                ],
              },
            },
            {
              "authorityName" => "Kingsmen Tailors",
              "authoritySlug" => "kingsmen-tailors",
              "authorityContact" => {
                "website" => "",
                "email" => "",
                "phone" => "020 007 007",
                "address" => "Savile Row",
              },
              "authorityInteractions" => {
                "apply" => [
                  {
                    "url" => "/licence-to-kill/kingsmen-tailors/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                ],
              },
            },

          ]

          stub_licence_exists(
            "1071-5-1/00BK",
            "isLocationSpecific" => true,
            "isOfferedByCounty" => false,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => authorities,
          )

          visit "/licence-to-kill"

          fill_in "postcode", with: "SW1A 1AA"
          click_on "Find"
        end

        should "show details for the first authority only" do
          within("#overview") do
            assert page.has_content?("Westminster")
            assert_not page.has_content?("Kingsmen Tailors")
          end
        end
      end
    end

    context "when visiting the licence with an invalid formatted postcode" do
      setup do
        stub_locations_api_does_not_have_a_bad_postcode("Not valid")
        visit "/licence-to-kill"

        fill_in "postcode", with: "Not valid"
        click_on "Find"
      end

      should "remain on the licence page" do
        assert_equal "/licence-to-kill", current_path
      end

      should "see an error message" do
        assert page.has_content? "This isn't a valid postcode."
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "Not valid"
      end
    end

    context "when visiting the licence with a postcode not present in LocationsApi" do
      setup do
        stub_locations_api_has_no_location("AB1 2AB")

        visit "/licence-to-kill"

        fill_in "postcode", with: "AB1 2AB"
        click_on "Find"
      end

      should "remain on the licence page" do
        assert_equal "/licence-to-kill", current_path
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find this postcode."
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "AB1 2AB"
      end
    end

    context "when visiting the licence with a postcode that has no local authority" do
      setup do
        stub_locations_api_has_location("XM4 5HQ", [{ "local_custodian_code" => 123 }])

        stub_local_links_manager_does_not_have_a_custodian_code(123)

        visit "/licence-to-kill"

        fill_in "postcode", with: "XM4 5HQ"
        click_on "Find"
      end

      should "remain on the licence page" do
        assert_equal "/licence-to-kill", current_path
      end

      should "see an error message" do
        assert page.has_content? "We couldn't find a council for this postcode."
      end

      should "re-populate the invalid input" do
        assert page.has_field? "postcode", with: "XM4 5HQ"
      end
    end
  end

  context "given a non-location specific licence" do
    setup do
      @payload = {
        base_path: "/licence-to-turn-off-a-telescreen",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to turn off a telescreen",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
          licence_overview: "The place where there is no darkness",
        },
      }

      stub_content_store_has_item("/licence-to-turn-off-a-telescreen", @payload)
    end

    context "with multiple authorities" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Plenty",
            "authoritySlug" => "miniplenty",
            "authorityInteractions" => {
              "apply" => [{
                "url" => "/licence-to-turn-off-a-telescreen/ministry-of-plenty/apply-1",
                "description" => "Apply for your licence to turn off a telescreen",
                "payment" => "none",
                "introduction" => "some intro",
                "usesLicensify" => true,
              }],
            },
          },
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [{
                "url" => "/licence-to-turn-off-a-telescreen/ministry-of-love/apply-1",
                "description" => "Apply for your licence to turn off a telescreen",
                "payment" => "none",
                "introduction" => "",
                "usesLicensify" => true,
              }],
            },
          },
          {
            "authorityName" => "Ministry of Truth",
            "authoritySlug" => "minitrue",
            "authorityInteractions" => {
              "apply" => [{
                "url" => "/licence-to-turn-off-a-telescreen/ministry-of-truth/apply-1",
                "description" => "Apply for your licence to turn off a telescreen",
                "payment" => "none",
                "introduction" => "",
                "usesLicensify" => true,
              }],
            },
          },
          {
            "authorityName" => "Ministry of Peace",
            "authoritySlug" => "minipax",
            "authorityInteractions" => {
              "apply" => [{
                "url" => "/licence-to-turn-off-a-telescreen/ministry-of-peace/apply-1",
                "description" => "Apply for your licence to turn off a telescreen",
                "payment" => "none",
                "introduction" => "",
                "usesLicensify" => true,
              }],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )
      end

      context "when visiting the license and specifying an authority" do
        setup do
          visit "/licence-to-turn-off-a-telescreen/minitrue"
        end

        should "display correct licence" do
          assert page.has_content?("The issuing authority for this licence is Ministry of Truth")
        end
      end

      context "when visiting the licence without specifying an authority" do
        setup do
          visit "/licence-to-turn-off-a-telescreen"
        end

        should "display the title" do
          assert page.has_content?("Licence to turn off a telescreen")
        end

        should "see the available authorities in a list" do
          assert page.has_content?("Ministry of Peace")
          assert page.has_content?("Ministry of Love")
          assert page.has_content?("Ministry of Truth")
          assert page.has_content?("Ministry of Plenty")
        end

        context "when selecting an authority" do
          setup do
            choose "Ministry of Love"
            click_on "Get started"
          end

          should "redirect to the authority slug" do
            assert_equal "/licence-to-turn-off-a-telescreen/miniluv", current_path
          end

          should "display interactions for licence" do
            click_on "How to apply"
            assert current_path == "/licence-to-turn-off-a-telescreen/miniluv/apply"

            assert_has_button_as_link(
              "Apply online",
              href: "/licence-to-turn-off-a-telescreen/ministry-of-love/apply-1",
              start: true,
            )
          end
        end
      end
    end

    context "with a single authority" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-turn-off-a-telescreen/ministry-of-love/apply-1",
                  "description" => "Apply for your licence to turn off a telescreen",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )
      end

      context "when visiting the licence" do
        setup do
          visit "/licence-to-turn-off-a-telescreen"
        end

        should "display the title" do
          assert page.has_content?("Licence to turn off a telescreen")
        end

        should "show licence actions for the single authority" do
          within("#content nav") do
            assert page.has_link? "How to apply", href: "/licence-to-turn-off-a-telescreen/miniluv/apply"
          end
        end

        should "display the interactions for licence" do
          click_on "How to apply"
          assert_has_button_as_link(
            "Apply online",
            href: "/licence-to-turn-off-a-telescreen/ministry-of-love/apply-1",
            start: true,
          )
        end

        should "show overview section" do
          within("#overview") do
            assert page.has_content?("The place where there is no darkness")
          end
        end
      end
    end
  end

  context "given a licence edition with continuation link" do
    setup do
      @payload = {
        base_path: "/artistic-license",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Artistic License",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          "will_continue_on" => "another planet",
          "continuation_link" => "http://gov.uk/blah",
        },
      }

      stub_content_store_has_item("/artistic-license", @payload)
    end

    context "when visiting the licence" do
      setup do
        visit "/artistic-license"
      end

      should "not see a location form" do
        assert_not page.has_field?("postcode")
      end

      should "see a 'Start now' button" do
        assert page.has_content?("Start now")
      end
    end

    context "when visiting the licence with an authority slug" do
      setup do
        visit "/artistic-license/miniluv"
      end

      should "redirect to the search page" do
        assert_current_url "/artistic-license"
      end
    end
  end

  context "given a licence which does not exist in licensify and uses authority url" do
    setup do
      @payload = {
        base_path: "/some-licence",
        document_type: "licence",
        format: "licence",
        phase: "beta",
        schema_name: "licence",
        title: "Licence of some type",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          lgsl_code: 461,
          lgil_code: 8,
          licence_identifier: "1071-5-1",
          licence_overview: "This is a licence.\n",
        },
      }

      stub_content_store_has_item("/a-licence", @payload)

      configure_locations_api_and_local_authority("SW1A 1AA", %w[a-council], 5990)
      stub_local_links_manager_does_not_have_an_authority("not-a-valid-council-name")

      authorities = [
        {
          "authorityName" => "A Council",
          "authoritySlug" => "a-council",
          "authorityContact" => {
            "website" => "",
            "email" => "",
            "phone" => "020 7641 6000",
            "address" => "P.O. Box 123\nSome Town\nXY1 1AB",
          },
          "authorityInteractions" => {
            "apply" => [
              {
                "url" => "http://some-council-website",
                "description" => "Apply for your licence",
                "payment" => "none",
                "introduction" => "This licence is issued online",
                "usesLicensify" => false,
                "usesAuthorityUrl" => true,
              },
            ],
          },
        },
      ]
      stub_licence_exists(
        "1071-5-1",
        "isLocationSpecific" => true,
        "isOfferedByCounty" => false,
        "geographicalAvailability" => %w[England Wales],
        "issuingAuthorities" => authorities,
      )
      stub_licence_exists(
        "1071-5-1/00BK",
        "isLocationSpecific" => true,
        "isOfferedByCounty" => false,
        "geographicalAvailability" => %w[England Wales],
        "issuingAuthorities" => authorities,
      )
    end

    should "show message to contact local council through their website" do
      visit "/a-licence/a-council/apply"

      assert page.has_content? "To obtain this licence, you need to contact the authority directly"
      assert page.has_content? "To continue, go to"
      assert page.has_link? "A Council", href: "http://some-council-website"
    end
  end

  context "given a licence which does not exist in licensify" do
    setup do
      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)

      stub_licence_does_not_exist("1071-5-1")
    end

    should "show message to contact local council" do
      visit "/licence-to-kill"

      assert page.has_content?("You can't apply for this licence online")
      assert page.has_content?("Contact your local council")
    end
  end

  context "given that licensify times out" do
    setup do
      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)
      stub_licence_times_out("1071-5-1")
    end

    should "show an error" do
      visit "/licence-to-kill"
      assert_equal page.status_code, 503
    end
  end

  context "given that licensify errors" do
    setup do
      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)
      stub_licence_returns_error("1071-5-1")
    end

    should "show an error" do
      visit "/licence-to-kill"
      assert_equal page.status_code, 503
    end
  end

  context "given the usesLicensify parameter" do
    setup do
      @payload = {
        base_path: "/licence-to-kill",
        document_type: "licence",
        format: "licence",
        schema_name: "licence",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          licence_identifier: "1071-5-1",
        },
      }

      stub_content_store_has_item("/licence-to-kill", @payload)
    end

    context "when visiting an authority with no actions" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {},
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title" do
        assert page.has_content?("Licence to kill")
      end

      should "not display authority" do
        assert_not page.has_content? "Ministry of Love"
        assert_not page.has_button? "Get started"
      end

      should "display the licence unavailable message" do
        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end
    end

    context "when there's at least one action with usesLicensify set to true" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title" do
        assert page.has_content?("Licence to kill")
      end

      should "display the authority" do
        assert page.has_content?("Ministry of Love")
      end

      should "show licence actions that have usesLicensify set to true" do
        within("#content nav") do
          assert page.has_link? "How to apply", href: "/licence-to-kill/miniluv/apply"
        end
      end

      should "show licence actions that have usesLicensify set to false" do
        within("#content nav") do
          assert page.has_link? "How to renew", href: "/licence-to-kill/miniluv/renew"
        end
      end

      should "display the interactions for the licence if usesLicensify is set to true" do
        click_link "How to apply"

        assert current_path == "/licence-to-kill/miniluv/apply"

        assert_has_button_as_link(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-1",
          start: true,
        )
        assert_not page.has_content?("You can't apply for this licence online")
        assert_not page.has_content?("Contact your local council")
      end

      should "not display the interactions for the licence if usesLicensify is set to false" do
        click_link "How to renew"

        assert current_path == "/licence-to-kill/miniluv/renew"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/renew-1",
          start: true,
        )
        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end
    end

    context "when all actions have usesLicensify set to false" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title" do
        assert page.has_content?("Licence to kill")
      end

      should "display authority" do
        assert page.has_content? "Ministry of Love"
      end

      should "display the actions" do
        assert page.has_content? "Overview"
        assert page.has_link? "How to apply", href: "/licence-to-kill/miniluv/apply"
        assert page.has_link? "How to renew", href: "/licence-to-kill/miniluv/renew"
      end

      should "not display the licence unavailable message on the main licence page" do
        assert_not page.has_content?("You can't apply for this licence online")
        assert_not page.has_content?("Contact your local council")
      end

      should "display the licence unavailable message after you click on the first action" do
        click_on "How to apply"

        assert current_path == "/licence-to-kill/miniluv/apply"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-1",
          start: true,
        )

        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end

      should "display the licence unavailable message after you click on the second action" do
        click_on "How to renew"

        assert current_path == "/licence-to-kill/miniluv/renew"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/renew-1",
          start: true,
        )

        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end
    end

    context "when usesLicensify is missing for one action" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title and authority" do
        assert page.has_content? "Licence to kill"
        assert page.has_content? "Ministry of Love"
      end

      should "show licence actions that don't have the usesLicensify param" do
        within("#content nav") do
          assert page.has_link? "How to apply", href: "/licence-to-kill/miniluv/apply"
        end
      end

      should "show licence actions that have usesLicensify set to true" do
        within("#content nav") do
          assert page.has_link? "How to renew", href: "/licence-to-kill/miniluv/renew"
        end
      end

      should "not display interactions for licence with missing usesLicensify" do
        click_on "How to apply"

        assert current_path == "/licence-to-kill/miniluv/apply"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-1",
          start: true,
        )

        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end

      should "display interactions for licence with usesLicensify set to true" do
        click_on "How to renew"

        assert current_path == "/licence-to-kill/miniluv/renew"

        assert_has_button_as_link(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/renew-1",
          start: true,
        )

        assert_not page.has_content?("You can't apply for this licence online")
        assert_not page.has_content?("Contact your local council")
      end
    end

    context "when usesLicensify is missing for all actions" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title" do
        assert page.has_content?("Licence to kill")
      end

      should "display authority" do
        assert page.has_content? "Ministry of Love"
      end

      should "display the actions" do
        assert page.has_content? "Overview"
        assert page.has_link? "How to apply", href: "/licence-to-kill/miniluv/apply"
        assert page.has_link? "How to renew", href: "/licence-to-kill/miniluv/renew"
      end

      should "not display the licence unavailable message on the main licence page" do
        assert_not page.has_content?("You can't apply for this licence online")
        assert_not page.has_content?("Contact your local council")
      end

      should "display the licence unavailable message after you click on an action" do
        click_on "How to apply"

        assert current_path == "/licence-to-kill/miniluv/apply"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-1",
          start: true,
        )

        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end
    end

    context "when an action has multiple links, some with usesLicensify set to true" do
      setup do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-2",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-3",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
              "renew" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
                {
                  "url" => "/licence-to-kill/ministry-of-love/renew-2",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
            },
          },
        ]

        stub_licence_exists(
          "1071-5-1",
          "isLocationSpecific" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authorities,
        )

        visit "/licence-to-kill"
      end

      should "display the title" do
        assert page.has_content?("Licence to kill")
      end

      should "display the authority" do
        assert page.has_content?("Ministry of Love")
      end

      should "show licence actions that have usesLicensify set to true" do
        within("#content nav") do
          assert page.has_link? "How to apply", href: "/licence-to-kill/miniluv/apply"
        end
      end

      should "show licence actions that have usesLicensify set to false" do
        within("#content nav") do
          assert page.has_link? "How to renew", href: "/licence-to-kill/miniluv/renew"
        end
      end

      should "display the interactions for the licence if usesLicensify is set to true for a link" do
        click_link "How to apply"

        assert current_path == "/licence-to-kill/miniluv/apply"

        assert_has_button_as_link(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-1",
          start: true,
        )
        assert_has_button_as_link(
          "Apply online",
          start: true,
          href: "/licence-to-kill/ministry-of-love/apply-3",
        )

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/apply-2",
          start: true,
        )
        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end

      should "not display the interactions for the licence if usesLicensify is set to false or is missing for a link" do
        click_link "How to renew"

        assert current_path == "/licence-to-kill/miniluv/renew"

        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/renew-1",
          start: true,
        )
        refute_has_button_component(
          "Apply online",
          href: "/licence-to-kill/ministry-of-love/renew-2",
          start: true,
        )
        assert page.has_content?("You can't apply for this licence online")
        assert page.has_content?("Contact your local council")
      end
    end
  end
end
