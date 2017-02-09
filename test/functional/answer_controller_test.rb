require "test_helper"

class AnswerControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      content_store_has_random_item(base_path: "/molehills", schema: 'answer')
    end

    context "for live content" do
      should "set the cache expiry headers" do
        get :show, slug: "molehills"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "molehills", format: 'json'

        assert_redirected_to "/api/molehills.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_has_unpublished_artefact("molehills", 3)
        content_store_has_random_item(base_path: '/molehills', schema: 'answer')
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "molehills", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end
  end
end
