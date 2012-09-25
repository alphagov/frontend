require 'test_helper'
require 'webmock/test_unit'
WebMock.disable_net_connect!(:allow_localhost => true)
require 'gds_api/part_methods'
require 'gds_api/test_helpers/publisher'
require 'gds_api/test_helpers/panopticon'

class LicenceLocationTest < ActionController::TestCase

  tests RootController
  include Rack::Geo::Utils

  context "given a licence exists in publisher and panopticon" do
    setup do
      content_api_has_an_artefact('licence-to-kill')
      publication_exists(
        "slug" => "licence-to-kill",
        "alternative_title" => "",
        "overview" => "",
        "title" => "Licence to Kill",
        "type" => "licence"
      )
    end

    context "loading the licence edition without any location" do
      should "return the normal content for a page" do
        get :publication, slug: "licence-to-kill"

        assert_response :success
        assert_equal assigns(:publication).title, "Licence to Kill"
      end
    end

    context "loading the licence edition when posting a location" do
      setup do
        councils = { "council" => [
          {"id" => 2240, "name" => "Staffordshire County Council", "type" => "CTY", "ons" => "41"},
          {"id" => 2432, "name" => "Staffordshire Moorlands District Council", "type" => "DIS", "ons" => "41UH"},
          {"id" => 15636, "name" => "Cheadle and Checkley", "type" => "CED"}
        ]}
        request.env["HTTP_X_GOVGEO_STACK"] = encode_stack councils

        get :publication, slug: "licence-to-kill"
      end

      should "redirect to the slug for the lowest level authority" do
        assert_redirected_to "/licence-to-kill/staffordshire-moorlands"
      end
    end
  end

end
