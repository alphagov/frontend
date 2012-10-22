require 'integration_test_helper'

class Mirrorer_Test < ActionDispatch::IntegrationTest

  setup do
    page.driver.browser.header('X-Govuk-Mirrorer', '1')
  end

  context "local transactions" do
    context "given a local transaction exists" do
      setup do
        @artefact = artefact_for_slug('find-local-clown').merge({
          "title" => "Find your local clown",
          "format" => "local_transaction",
          "details" => {
            "format" => "LocalTrasnaction",
            "introduction" => "Information about your local clowns.",
            "local_service" => {
              "description" => "Find out about clowns in your area",
              "lgsl_code" => 461,
              "providing_tier" => [
                "district",
                "unitary",
                "county"
              ]
            }
          }
        })

        content_api_has_an_artefact("find-local-clown", @artefact)
      end

      should "show a dropdown list of all councils" do
        visit "/find-local-clown"

        within "select#authority" do
          assert page.has_content?("South Ribble Borough Council")
          assert page.has_content?("Barrow-in-Furness Borough Council")
          assert page.has_content?("Camden Borough Council")
        end
      end
    end
  end

  context "licences" do
    context "given a licence exists" do
      setup do
        @artefact = artefact_for_slug('licence-to-kill').merge({
          "title" => "Licence to kill",
          "format" => "licence",
          "details" => {
            "format" => "Licence",
            "licence_overview" => "You only live twice, Mr Bond.\n",
            "licence" => {
              "location_specific" => true,
              "availability" => ["England","Wales"],
              "authorities" => [ ]
            }
          }
        })

        content_api_has_an_artefact('licence-to-kill', @artefact)
      end

      should "show a dropdown list of all councils" do
        visit "/licence-to-kill"

        within "select#authority" do
          assert page.has_content?("South Ribble Borough Council")
          assert page.has_content?("Barrow-in-Furness Borough Council")
          assert page.has_content?("Camden Borough Council")
        end
      end
    end
  end

end
