require "test_helper"

class PlaceControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      @artefact = artefact_for_slug('passport-interview-office')
      @artefact["format"] = "place"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('passport-interview-office', artefact: @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "passport-interview-office"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "passport-interview-office", format: 'json'

        assert_redirected_to "/api/passport-interview-office.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("passport-interview-office", 3, artefact: @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "passport-interview-office", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end
  end
end
