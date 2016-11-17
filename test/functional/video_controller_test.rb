require "test_helper"

class VideoControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      @artefact = artefact_for_slug('test-video')
      @artefact["format"] = "video"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('test-video', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "test-video"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "test-video", format: 'json'

        assert_redirected_to "/api/test-video.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("test-video", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "test-video", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end
  end
end
