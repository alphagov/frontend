require "gds_api/test_helpers/locations_api"
require "gds_api/test_helpers/local_links_manager"
require "gds_api/test_helpers/licence_application"

RSpec.describe "LicenceTransaction" do
  include GdsApi::TestHelpers::LocationsApi
  include GdsApi::TestHelpers::LocalLinksManager
  include GdsApi::TestHelpers::LicenceApplication
  include LocationHelpers

  before do
    @payload = {
      base_path: "/find-licences/licence-to-kill",
      document_type: "licence_transaction",
      schema_name: "specialist_document",
      title: "Licence to kill",
      public_updated_at: "2012-10-02T12:30:33.483Z",
      description: "Descriptive licence text.",
      details: {
        body: "You only live twice, Mr Bond.\n",
        metadata: {
          licence_transaction_licence_identifier: "1071-5-1",
        },
      },
    }
  end

  context "with a location specific licence" do
    before do
      configure_locations_api_and_local_authority("SW1A 1AA", %w[westminster], 5990)
      stub_local_links_manager_does_not_have_an_authority("not-a-valid-council-name")
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
      stub_licence_exists(
        "1071-5-1",
        "isLocationSpecific" => true,
        "isOfferedByCounty" => false,
        "geographicalAvailability" => %w[England Wales],
        "issuingAuthorities" => [],
      )
    end

    context "when visiting the licence search page" do
      before { visit "/find-licences/licence-to-kill" }

      it "renders the licence page" do
        expect(page.status_code).to eq(200)
        within("head", visible: :all) do
          expect(page).to have_title("Licence to kill - GOV.UK", exact: true)
        end
        within("#content") do
          within(".gem-c-heading h1") { expect(page).to have_title("Licence to kill") }
          within(".postcode-search-form") do
            expect(page).to have_field("Enter a postcode")
            expect(page).to have_css("button", text: "Find")
          end
          expect(page).not_to have_content("Please enter a valid full UK postcode.")
          within("#overview") do
            expect(page).to have_content("You only live twice, Mr Bond.")
          end
        end
      end

      it "adds GA4 form submit attributes" do
        data_module = page.find("form")["data-module"]
        expected_data_module = "ga4-form-tracker"
        ga4_form_attribute = page.find("form")["data-ga4-form"]
        ga4_expected_object = "{\"event_name\":\"form_submit\",\"action\":\"submit\",\"type\":\"licence transaction\",\"text\":\"Find\",\"section\":\"Enter a postcode\",\"tool_name\":\"Licence to kill\"}"

        expect(data_module).to eq(expected_data_module)
        expect(ga4_form_attribute).to eq(ga4_expected_object)
      end
    end

    context "when visiting the licence with a valid postcode" do
      context "when it's a unitary or district local authority" do
        before do
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
                    "url" => "/new-licence/westminster/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                  {
                    "url" => "/new-licence/westminster/apply-2",
                    "description" => "Apply for your licence to hold gadgets",
                    "payment" => "none",
                    "introduction" => "Q-approval required.",
                    "usesLicensify" => true,
                  },
                ],
                "renew" => [
                  {
                    "url" => "/new-licence/westminster/renew-1",
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
          visit "/find-licences/licence-to-kill"
          fill_in("postcode", with: "SW1A 1AA")
          click_on("Find your local council")
        end

        it "redirects to the appropriate authority slug" do
          expect(page).to have_current_path("/find-licences/licence-to-kill/westminster", ignore_query: true)
        end

        it "includes the authority name in the title element" do
          within("head", visible: :all) do
            expect(page).to have_title("Licence to kill: Westminster City Council - GOV.UK", exact: true)
          end
        end

        it "displays the authority name" do
          within("#overview") { expect(page).to have_content("Westminster") }
        end

        it "shows available licence actions" do
          within("#content nav") do
            expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/westminster/apply")
            expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/westminster/renew")
          end
        end

        it "shows overview section" do
          within("#overview") do
            expect(page).to have_content("You only live twice, Mr Bond.")
          end
        end

        context "when visiting a licence action" do
          before { click_link("How to apply") }

          it "includes the action in the title element" do
            expect(page).to have_title("Licence to kill: How to apply - GOV.UK", exact: true)
          end

          it "displays the page content" do
            expect(page).to have_content("Licence to kill")
            expect(page).to have_selector("h2", text: "How to apply")
          end

          it "displays a button to apply for the licence" do
            expect(page).to have_button_as_link("Apply online", href: "/new-licence/westminster/apply-1", start: true)
            expect(page).to have_button_as_link("Apply online", href: "/new-licence/westminster/apply-1", start: true)
          end
        end

        it "returns a 404 for an invalid action" do
          visit "/find-licences/licence-to-kill/westminster/blah"

          expect(page.status_code).to eq(404)

          visit "/find-licences/licence-to-kill/westminster/change"

          expect(page.status_code).to eq(404)
        end

        it "returns a 404 for an invalid authority" do
          visit "/find-licences/licence-to-kill/not-a-valid-council-name"

          expect(page.status_code).to eq(404)
        end

        it "adds GA4 form_complete attributes" do
          data_module = page.find("article")["data-module"]
          expected_data_module = "ga4-link-tracker ga4-auto-tracker"
          ga4_auto_attribute = page.find("article")["data-ga4-auto"]
          ga4_expected_object = "{\"event_name\":\"form_complete\",\"action\":\"complete\",\"type\":\"licence transaction\",\"text\":\"From Westminster City Council\",\"tool_name\":\"Licence to kill\"}"

          expect(data_module).to eq(expected_data_module)
          expect(ga4_auto_attribute).to eq(ga4_expected_object)
        end

        it "does not add ga4-auto if you're on a page other than '1. Overview'" do
          stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
          visit "/find-licences/licence-to-kill/westminster/apply"
          data_module = page.find("article")["data-module"]
          expected_data_module = "ga4-link-tracker"
          ga4_auto_attribute = page.find("article")["data-ga4-auto"]

          expect(data_module).to eq(expected_data_module)
          expect(ga4_auto_attribute).to be_nil
        end

        it "adds GA4 information click attributes" do
          data_module = page.find("article")["data-module"]
          expected_data_module = "ga4-link-tracker ga4-auto-tracker"
          ga4_link_attribute = page.find("article")["data-ga4-link"]
          ga4_expected_object = "{\"event_name\":\"information_click\",\"action\":\"information click\",\"type\":\"licence transaction\",\"tool_name\":\"Licence to kill\"}"
          expect(data_module).to eq(expected_data_module)
          expect(ga4_link_attribute).to eq(ga4_expected_object)
        end

        it "adds GA4 change response attributes" do
          ga4_link_attribute = page.find(".contact > p > a")["data-ga4-link"]
          ga4_expected_object = "{\"event_name\":\"form_change_response\",\"action\":\"change response\",\"type\":\"licence transaction\",\"tool_name\":\"Licence to kill\"}"

          expect(ga4_link_attribute).to eq(ga4_expected_object)
        end
      end

      context "when it's a county local authority" do
        before do
          stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
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
                    "url" => "/licence-to-kill/buckinghamshire/apply-1",
                    "description" => "Apply for your licence to kill",
                    "payment" => "none",
                    "introduction" => "This licence is issued shaken, not stirred.",
                    "usesLicensify" => true,
                  },
                  {
                    "url" => "/licence-to-kill/buckinghamshire/apply-2",
                    "description" => "Apply for your licence to hold gadgets",
                    "payment" => "none",
                    "introduction" => "Q-approval required.",
                    "usesLicensify" => true,
                  },
                ],
                "renew" => [
                  {
                    "url" => "/licence-to-kill/buckinghamshire/renew-1",
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
            "isOfferedByCounty" => true,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => authorities,
          )
          stub_licence_exists(
            "1071-5-1",
            "isLocationSpecific" => true,
            "isOfferedByCounty" => true,
            "geographicalAvailability" => %w[England Wales],
            "issuingAuthorities" => [],
          )
          visit "/find-licences/licence-to-kill"
          fill_in("postcode", with: "HP20 2QF")
          click_on("Find your local council")
        end

        it "redirects to the appropriate authority slug" do
          expect(page).to have_current_path("/find-licences/licence-to-kill/buckinghamshire", ignore_query: true)
        end

        it "includes the authority name in the title element" do
          expect(page).to have_title("Licence to kill: Buckinghamshire Council - GOV.UK", exact: true)
        end

        it "has an apply link" do
          expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/buckinghamshire/apply")
        end

        context "when the local authority doesn't have a SNAC" do
          before do
            configure_locations_api_and_local_authority("DT11 0SF", %w[dorset], 440, snac: nil, gss: "E06000069")
            authorities = [
              {
                "authorityName" => "Dorset Council",
                "authoritySlug" => "dorset",
                "authorityContact" => {
                  "website" => "",
                  "email" => "",
                  "phone" => "",
                  "address" => "",
                },
                "authorityInteractions" => {
                  "apply" => [
                    {
                      "url" => "/licence-to-kill/dorset/apply-1",
                      "description" => "Apply for your licence to kill",
                      "payment" => "none",
                      "introduction" => "This licence is issued shaken, not stirred.",
                      "usesLicensify" => true,
                    },
                    {
                      "url" => "/licence-to-kill/dorset/apply-2",
                      "description" => "Apply for your licence to hold gadgets",
                      "payment" => "none",
                      "introduction" => "Q-approval required.",
                      "usesLicensify" => true,
                    },
                  ],
                  "renew" => [
                    {
                      "url" => "/licence-to-kill/dorset/renew-1",
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
              "1071-5-1/E06000069",
              "isLocationSpecific" => true,
              "isOfferedByCounty" => true,
              "geographicalAvailability" => %w[England Wales],
              "issuingAuthorities" => authorities,
            )
            visit "/find-licences/licence-to-kill"
            fill_in("postcode", with: "DT11 0SF")
            click_on("Find your local council")
          end

          it "redirects to the appropriate authority slug" do
            expect(page).to have_current_path("/find-licences/licence-to-kill/dorset", ignore_query: true)
          end

          it "includes the authority name in the title element" do
            expect(page).to have_title("Licence to kill: Dorset Council - GOV.UK", exact: true)
          end

          it "has an apply link" do
            expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/dorset/apply")
          end
        end
      end

      context "when there are more than one licensing authority" do
        before do
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
                    "url" => "/new-licence/westminster/apply-1",
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
                    "url" => "/new-licence/kingsmen-tailors/apply-1",
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
          visit "/find-licences/licence-to-kill"
          fill_in("postcode", with: "SW1A 1AA")
          click_on("Find your local council")
        end

        it "shows details for the first licensing authority only" do
          within("#overview") do
            expect(page).to have_content("Westminster")
            expect(page).not_to have_content("Kingsmen Tailors")
          end
        end

        it "includes the first licencing authority name only in the title element" do
          expect(page).to have_title("Licence to kill: Westminster City Council - GOV.UK", exact: true)
        end
      end
    end

    context "when visiting the licence with an invalid formatted postcode" do
      before do
        stub_locations_api_does_not_have_a_bad_postcode("Not valid")
        visit "/find-licences/licence-to-kill"
        fill_in("postcode", with: "Not valid")
        click_on("Find your local council")
      end

      it "prefixes 'Error' in the title element" do
        expect(page).to have_title("Error: Licence to kill - GOV.UK", exact: true)
      end

      it "remains on the licence page" do
        expect(page).to have_current_path("/find-licences/licence-to-kill", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content("This isn't a valid postcode.")
      end

      it "re-populates the invalid input" do
        expect(page).to have_field("postcode", with: "Not valid")
      end

      it "adds the GA4 form error attributes" do
        data_module = page.find("#error")["data-module"]
        expected_data_module = "ga4-auto-tracker govuk-error-summary"
        ga4_error_attribute = page.find("#error")["data-ga4-auto"]
        ga4_expected_object = "{\"event_name\":\"form_error\",\"action\":\"error\",\"type\":\"licence transaction\",\"text\":\"This isn't a valid postcode.\",\"section\":\"Enter a postcode\",\"tool_name\":\"Licence to kill\"}"

        expect(data_module).to eq(expected_data_module)
        expect(ga4_error_attribute).to eq(ga4_expected_object)
      end
    end

    context "when visiting the licence with a postcode not present in Locations API" do
      before do
        stub_locations_api_has_no_location("AB1 2AB")
        visit "/find-licences/licence-to-kill"
        fill_in("postcode", with: "AB1 2AB")
        click_on("Find your local council")
      end

      it "prefixes 'Error' in the title element" do
        expect(page).to have_title("Error: Licence to kill - GOV.UK", exact: true)
      end

      it "remains on the licence page" do
        expect(page).to have_current_path("/find-licences/licence-to-kill", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content("We couldn't find this postcode.")
      end

      it "re-populates the invalid input" do
        expect(page).to have_field("postcode", with: "AB1 2AB")
      end
    end

    context "when visiting the licence with a postcode that has no local authority" do
      before do
        stub_locations_api_has_location("XM4 5HQ", [{ "local_custodian_code" => 123 }])
        stub_local_links_manager_does_not_have_a_custodian_code(123)
        visit "/find-licences/licence-to-kill"
        fill_in("postcode", with: "XM4 5HQ")
        click_on("Find your local council")
      end

      it "prefixes 'Error' in the title element" do
        expect(page).to have_title("Error: Licence to kill - GOV.UK", exact: true)
      end

      it "remains on the licence page" do
        expect(page).to have_current_path("/find-licences/licence-to-kill", ignore_query: true)
      end

      it "shows an error message" do
        expect(page).to have_content("We couldn't find a council for this postcode.")
      end

      it "re-populates the invalid input" do
        expect(page).to have_field("postcode", with: "XM4 5HQ")
      end
    end

    context "when visiting a licence that has district and county authorities" do
      before do
        stub_locations_api_has_location("ST10 4DB", [{ "latitude" => 51.5010096, "longitude" => -0.141587, "local_custodian_code" => 1234 }])
        authority_for_staffordshire = [
          {
            "authorityName" => "Staffordshire",
            "authoritySlug" => "staffordshire",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your Licence to kill",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
            },
          },
        ]
        authority_for_staffordshire_moorlands = [
          {
            "authorityName" => "Staffordshire Moorlands",
            "authoritySlug" => "staffordshire-moorlands",
            "authorityInteractions" => {},
          },
        ]
        stub_local_links_manager_has_a_district_and_county_local_authority("staffordshire-moorlands", "staffordshire", district_snac: "41UH", county_snac: "41", local_custodian_code: 1234)
        stub_licence_exists(
          "1071-5-1/41",
          "isLocationSpecific" => true,
          "isOfferedByCounty" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authority_for_staffordshire,
        )
        stub_licence_exists(
          "1071-5-1/41UH",
          "isLocationSpecific" => true,
          "isOfferedByCounty" => false,
          "geographicalAvailability" => %w[England Wales],
          "issuingAuthorities" => authority_for_staffordshire_moorlands,
        )
        stub_local_links_manager_has_a_local_authority("staffordshire", local_custodian_code: 1234, snac: "41")
        visit "/find-licences/licence-to-kill"
        fill_in("postcode", with: "ST10 4DB")
        click_on("Find your local council")
      end

      it "includes the first licencing authority name only in the title element" do
        expect(page).to have_title("Licence to kill: Staffordshire - GOV.UK", exact: true)
      end

      it "returns the first authority with an actionable licence" do
        expect(page).to have_current_path("/find-licences/licence-to-kill/staffordshire", ignore_query: true)
      end
    end

    context "when visiting a authority licence that doesn't have any actionable licences" do
      before do
        configure_locations_api_and_local_authority("ST10 4DB", %w[staffordshire-moorlands], 1234, snac: "41UH")
        stub_licence_does_not_exist("1071-5-1/41UH")
        visit "/find-licences/licence-to-kill"
        fill_in("postcode", with: "ST10 4DB")
        click_on("Find your local council")
      end

      it "includes contact your council text in the title element" do
        expect(page).to have_title("Licence to kill: #{I18n.t('formats.local_transaction.contact_council')} - GOV.UK", exact: true)
      end

      it "returns licence not found template" do
        expect(page).to have_current_path("/find-licences/licence-to-kill", ignore_query: true)
        expect(page).to have_content("You cannot apply for this licence online.")
      end
    end

    context "when visiting the licence transaction with a postcode where multiple authorities are found" do
      context "when there are 5 or fewer addresses to choose from" do
        before do
          stub_locations_api_has_location(
            "CH25 9BJ",
            [
              { "address" => "House 1", "local_custodian_code" => "1" },
              { "address" => "House 2", "local_custodian_code" => "2" },
              { "address" => "House 3", "local_custodian_code" => "3" },
            ],
          )
          stub_local_links_manager_has_a_local_authority("Achester", local_custodian_code: 1)
          stub_local_links_manager_has_a_local_authority("Beechester", local_custodian_code: 2)
          stub_local_links_manager_has_a_local_authority("Ceechester", local_custodian_code: 3)
          visit "/find-licences/licence-to-kill"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find your local council")
        end

        it "includes the select address text in the title element" do
          expect(page).to have_title("Licence to kill: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
        end

        it "prompts you to choose your address" do
          expect(page).to have_content("Select an address")
        end

        it "displays radio buttons" do
          expect(page).to have_css(".govuk-radios")
        end

        it "contains a list of addresses mapped to authority slugs" do
          expect(page).to have_content("House 1")
          expect(page).to have_content("House 2")
          expect(page).to have_content("House 3")
        end
      end

      context "when there are 6 or more addresses to choose from" do
        before do
          stub_locations_api_has_location(
            "CH25 9BJ",
            [
              { "address" => "House 1", "local_custodian_code" => "1" },
              { "address" => "House 2", "local_custodian_code" => "2" },
              { "address" => "House 3", "local_custodian_code" => "3" },
              { "address" => "House 4", "local_custodian_code" => "4" },
              { "address" => "House 5", "local_custodian_code" => "5" },
              { "address" => "House 6", "local_custodian_code" => "6" },
              { "address" => "House 7", "local_custodian_code" => "7" },
            ],
          )
          stub_local_links_manager_has_a_local_authority("Achester", local_custodian_code: 1)
          stub_local_links_manager_has_a_local_authority("Beechester", local_custodian_code: 2)
          stub_local_links_manager_has_a_local_authority("Ceechester", local_custodian_code: 3)
          stub_local_links_manager_has_a_local_authority("Deechester", local_custodian_code: 4)
          stub_local_links_manager_has_a_local_authority("Eeechester", local_custodian_code: 5)
          stub_local_links_manager_has_a_local_authority("Feechester", local_custodian_code: 6)
          stub_local_links_manager_has_a_local_authority("Geechester", local_custodian_code: 7)
          visit "/find-licences/licence-to-kill"
          fill_in("postcode", with: "CH25 9BJ")
          click_on("Find your local council")
        end

        it "includes the select address text in the title element" do
          expect(page).to have_title("Licence to kill: #{I18n.t('formats.local_transaction.select_address')} - GOV.UK", exact: true)
        end

        it "prompts you to choose your address" do
          expect(page).to have_content("Select an address")
        end

        it "displays a dropdown select" do
          expect(page).to have_css(".govuk-select")
        end

        it "contains a list of addresses mapped to authority slugs" do
          expect(page).to have_content("House 1")
          expect(page).to have_content("House 2")
          expect(page).to have_content("House 3")
          expect(page).to have_content("House 4")
          expect(page).to have_content("House 5")
          expect(page).to have_content("House 6")
          expect(page).to have_content("House 7")
        end
      end
    end
  end

  context "with a non-location specific licence" do
    before do
      @payload = {
        base_path: "/find-licences/licence-to-kill",
        document_type: "licence_transaction",
        schema_name: "specialist_document",
        title: "Licence to kill",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          body: "You only live twice, Mr Bond.",
          metadata: {
            licence_transaction_licence_identifier: "1071-5-1",
          },
        },
      }
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
    end

    context "with a single authority" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/licence-to-kill/ministry-of-love/apply-1",
                  "description" => "Apply for your Licence to kill",
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
        before { visit "/find-licences/licence-to-kill" }

        it "includes the authority name in the title element" do
          expect(page).to have_title("Licence to kill: Ministry of Love - GOV.UK", exact: true)
        end

        it "displays the title" do
          expect(page).to have_content("Licence to kill")
        end

        it "shows licence actions for the single authority" do
          within("#content nav") do
            expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
          end
        end

        it "displays the interactions for licence" do
          click_on("How to apply")
          expect(page).to have_button_as_link("Apply online", href: "/licence-to-kill/ministry-of-love/apply-1", start: true)
        end

        it "shows overview section" do
          within("#overview") do
            expect(page).to have_content("You only live twice, Mr Bond.")
          end
        end
      end
    end
  end

  context "with a licence edition with continuation link" do
    before do
      @payload = {
        base_path: "/find-licences/artistic-license",
        document_type: "licence_transaction",
        schema_name: "specialist_document",
        title: "Artistic License",
        public_updated_at: "2012-10-02T12:30:33.483Z",
        description: "Descriptive licence text.",
        details: {
          metadata: {
            licence_transaction_will_continue_on: "another planet",
            licence_transaction_continuation_link: "http://gov.uk/blah",
          },
        },
      }
      stub_content_store_has_item("/find-licences/artistic-license", @payload)
    end

    context "when visiting the licence" do
      before { visit "/find-licences/artistic-license" }

      it "does not show a location form" do
        expect(page).not_to have_field("postcode")
      end

      it "uses the default text for the title element" do
        expect(page).to have_title("Artistic License - GOV.UK", exact: true)
      end

      it "shows a 'Start now' button" do
        expect(page).to have_content("Start now")
      end
    end

    context "when visiting the licence with an authority slug" do
      before { visit "/find-licences/artistic-license/miniluv" }

      it "redirects to the search page" do
        expect(page).to have_current_path("/find-licences/artistic-license", ignore_query: true)
      end
    end
  end

  context "with a licence which does not exist in licensify and uses authority url" do
    before do
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
      configure_locations_api_and_local_authority("SW1A 1AA", %w[a-council], 5990)
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

    it "shows message to contact local council through their website" do
      visit "/find-licences/licence-to-kill/a-council/apply"

      expect(page).to have_content("To obtain this licence, you need to contact the authority directly")
      expect(page).to have_content("To continue, go to")
      expect(page).to have_link("A Council", href: "http://some-council-website")
    end

    it "includes the action in the title element" do
      visit "/find-licences/licence-to-kill/a-council/apply"

      expect(page).to have_title("Licence to kill: How to apply - GOV.UK", exact: true)
    end
  end

  context "with a licence which does not exist in licensify" do
    before do
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
      stub_licence_does_not_exist("1071-5-1")
    end

    it "shows message to contact local council" do
      visit "/find-licences/licence-to-kill"

      expect(page).to have_content("You cannot apply for this licence online")
      expect(page).to have_content("Contact your local council")
    end

    it "includes contact your council text in the title element" do
      visit "/find-licences/licence-to-kill"

      expect(page).to have_title("Licence to kill: #{I18n.t('formats.local_transaction.contact_council')} - GOV.UK", exact: true)
    end

    it "contains GA4 auto attributes" do
      visit "/find-licences/licence-to-kill"
      data_module = page.find("div[data-ga4-auto]")["data-module"]
      expected_data_module = "ga4-auto-tracker"
      ga4_auto_attribute = page.find("div[data-ga4-auto]")["data-ga4-auto"]
      ga4_expected_object = "{\"event_name\":\"form_complete\",\"type\":\"licence transaction\",\"text\":\"You cannot apply for this licence online\",\"action\":\"complete\",\"tool_name\":\"Licence to kill\"}"

      expect(data_module).to eq(expected_data_module)
      expect(ga4_auto_attribute).to eq(ga4_expected_object)
    end
  end

  context "when licensify times out" do
    before do
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
      stub_licence_times_out("1071-5-1")
    end

    it "shows an error" do
      visit "/find-licences/licence-to-kill"
      expect(page.status_code).to eq(503)
    end
  end

  context "when licensify returns an error" do
    before do
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
      stub_licence_returns_error("1071-5-1")
    end

    it "shows an error" do
      visit "/find-licences/licence-to-kill"
      expect(page.status_code).to eq(503)
    end
  end

  context "with the usesLicensify parameter" do
    before do
      stub_content_store_has_item("/find-licences/licence-to-kill", @payload)
    end

    context "when visiting an authority with no actions" do
      before do
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
        visit "/find-licences/licence-to-kill"
      end

      it "displays the title" do
        expect(page).to have_content("Licence to kill")
      end

      it "does not display authority" do
        expect(page).not_to have_content("Ministry of Love")
        expect(page).not_to have_button("Get started")
      end

      it "displays the licence unavailable message" do
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end
    end

    context "when there's at least one action with usesLicensify set to true" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/new-licence/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
              "renew" => [
                {
                  "url" => "/new-licence/ministry-of-love/renew-1",
                  "description" => "Renew your licence",
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
        visit "/find-licences/licence-to-kill"
      end

      it "includes the authority name in the title element" do
        expect(page).to have_title("Licence to kill: Ministry of Love - GOV.UK", exact: true)
      end

      it "displays the authority" do
        expect(page).to have_content("Ministry of Love")
      end

      it "shows licence actions that have usesLicensify set to true" do
        within("#content nav") do
          expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
        end
      end

      it "shows licence actions that have usesLicensify set to false" do
        within("#content nav") do
          expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/miniluv/renew")
        end
      end

      it "displays the interactions for the licence if usesLicensify is set to true" do
        click_link("How to apply")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/apply", ignore_query: true)
        expect(page).to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-1", start: true)
        expect(page).not_to have_content("You cannot apply for this licence online")
        expect(page).not_to have_content("Contact your local council")
      end

      it "does not display the interactions for the licence if usesLicensify is set to false" do
        click_link("How to renew")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/renew", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/renew-1", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end
    end

    context "when all actions have usesLicensify set to false" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/new-licence/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
              ],
              "renew" => [
                {
                  "url" => "/new-licence/ministry-of-love/renew-1",
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
        visit "/find-licences/licence-to-kill"
      end

      it "displays the title" do
        expect(page).to have_content("Licence to kill")
      end

      it "displays authority" do
        expect(page).to have_content("Ministry of Love")
      end

      it "displays the actions" do
        expect(page).to have_content("Overview")
        expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
        expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/miniluv/renew")
      end

      it "does not display the licence unavailable message on the main licence page" do
        expect(page).not_to have_content("You cannot apply for this licence online")
        expect(page).not_to have_content("Contact your local council")
      end

      it "displays the licence unavailable message after you click on the first action" do
        click_on("How to apply")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/apply", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-1", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end

      it "displays the licence unavailable message after you click on the second action" do
        click_on("How to renew")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/renew", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/renew-1", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end
    end

    context "when usesLicensify is missing for one action" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/new-licence/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
              "renew" => [
                {
                  "url" => "/new-licence/ministry-of-love/renew-1",
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
        visit "/find-licences/licence-to-kill"
      end

      it "displays the title and authority" do
        expect(page).to have_content("Licence to kill")
        expect(page).to have_content("Ministry of Love")
      end

      it "shows licence actions that don't have the usesLicensify param" do
        within("#content nav") do
          expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
        end
      end

      it "shows licence actions that have usesLicensify set to true" do
        within("#content nav") do
          expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/miniluv/renew")
        end
      end

      it "does not display interactions for licence with missing usesLicensify" do
        click_on("How to apply")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/apply", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-1", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end

      it "displays interactions for licence with usesLicensify set to true" do
        click_on("How to renew")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/renew", ignore_query: true)
        expect(page).to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/renew-1", start: true)
        expect(page).not_to have_content("You cannot apply for this licence online")
        expect(page).not_to have_content("Contact your local council")
      end
    end

    context "when usesLicensify is missing for all actions" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/new-licence/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                },
              ],
              "renew" => [
                {
                  "url" => "/new-licence/ministry-of-love/renew-1",
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
        visit "/find-licences/licence-to-kill"
      end

      it "displays the title" do
        expect(page).to have_content("Licence to kill")
      end

      it "displays the authority" do
        expect(page).to have_content("Ministry of Love")
      end

      it "displays the actions" do
        expect(page).to have_content("Overview")
        expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
        expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/miniluv/renew")
      end

      it "does not display the licence unavailable message on the main licence page" do
        expect(page).not_to have_content("You cannot apply for this licence online")
        expect(page).not_to have_content("Contact your local council")
      end

      it "displays the licence unavailable message after you click on an action" do
        click_on("How to apply")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/apply", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-1", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end
    end

    context "when an action has multiple links, some with usesLicensify set to true" do
      before do
        authorities = [
          {
            "authorityName" => "Ministry of Love",
            "authoritySlug" => "miniluv",
            "authorityInteractions" => {
              "apply" => [
                {
                  "url" => "/new-licence/ministry-of-love/apply-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
                {
                  "url" => "/new-licence/ministry-of-love/apply-2",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
                {
                  "url" => "/new-licence/ministry-of-love/apply-3",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => true,
                },
              ],
              "renew" => [
                {
                  "url" => "/new-licence/ministry-of-love/renew-1",
                  "description" => "Apply for your licence",
                  "payment" => "none",
                  "introduction" => "",
                  "usesLicensify" => false,
                },
                {
                  "url" => "/new-licence/ministry-of-love/renew-2",
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
        visit "/find-licences/licence-to-kill"
      end

      it "displays the title" do
        expect(page).to have_content("Licence to kill")
      end

      it "displays the authority" do
        expect(page).to have_content("Ministry of Love")
      end

      it "shows licence actions that have usesLicensify set to true" do
        within("#content nav") do
          expect(page).to have_link("How to apply", href: "/find-licences/licence-to-kill/miniluv/apply")
        end
      end

      it "shows licence actions that have usesLicensify set to false" do
        within("#content nav") do
          expect(page).to have_link("How to renew", href: "/find-licences/licence-to-kill/miniluv/renew")
        end
      end

      it "displays the interactions for the licence if usesLicensify is set to true for a link" do
        click_link("How to apply")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/apply", ignore_query: true)
        expect(page).to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-1", start: true)
        expect(page).to have_button_as_link("Apply online", start: true, href: "/new-licence/ministry-of-love/apply-3")
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/apply-2", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end

      it "does not display the interactions for the licence if usesLicensify is set to false or is missing for a link" do
        click_link("How to renew")

        expect(page).to have_current_path("/find-licences/licence-to-kill/miniluv/renew", ignore_query: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/renew-1", start: true)
        expect(page).not_to have_button_as_link("Apply online", href: "/new-licence/ministry-of-love/renew-2", start: true)
        expect(page).to have_content("You cannot apply for this licence online")
        expect(page).to have_content("Contact your local council")
      end
    end
  end
end
