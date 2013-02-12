require 'test_helper'

require 'gds_api/part_methods'
require 'gds_api/test_helpers/panopticon'
require 'gds_api/test_helpers/mapit'

class LicenceLocationTest < ActionController::TestCase

  tests RootController
  include GdsApi::TestHelpers::Mapit

  context "given a licence exists" do
    setup do
      content_api_has_an_artefact('licence-to-kill', {
        "format" => "licence",
        "web_url" => "http://example.org/licence-to-kill",
        "title" => "Licence to kill",
        "details" => { }
      })
    end

    context "loading the licence edition without any location" do
      should "return the normal content for a page" do
        get :publication, slug: "licence-to-kill"

        assert_response :success
        assert_equal assigns(:publication).title, "Licence to kill"
      end

      should "set correct expiry headers" do
        get :publication, slug: "licence-to-kill"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    context "loading the licence edition when posting a location" do
      context "for an English local authority" do
        setup do
          mapit_has_a_postcode_and_areas("ST10 4DB", [0, 0], [
            { "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41"},
            { "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH"},
            { "name" => "Cheadle and Checkley", "type" => "CED" }
          ])

          post :publication, slug: "licence-to-kill", postcode: "ST10 4DB"
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/staffordshire-moorlands"
        end
      end

      context "for a Northern Irish local authority" do
        setup do
          mapit_has_a_postcode_and_areas("BT1 5GS", [0, 0], [
            { "name" => "Belfast City Council", "type" => "LGD", "ons" => "95Z"},
            { "name" => "Shaftesbury", "type" => "LGW", "ons" => "95Z24"},
          ])

          post :publication, slug: "licence-to-kill", postcode: "BT1 5GS"
        end

        should "redirect to the slug for the lowest level authority" do
          assert_redirected_to "/licence-to-kill/belfast"
        end
      end
    end
  end

end
