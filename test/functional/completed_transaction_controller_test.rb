require "test_helper"

class CompletedTransactionControllerTest < ActionController::TestCase
  context "GET show" do
    setup do
      @artefact = artefact_for_slug('done/no-promotion')
      @artefact["format"] = "completed_transaction"
    end

    context "for live content" do
      setup do
        content_api_and_content_store_have_page('done/no-promotion', @artefact)
      end

      should "set the cache expiry headers" do
        get :show, slug: "done/no-promotion"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end

      should "redirect json requests to the api" do
        get :show, slug: "done/no-promotion", format: 'json'

        assert_redirected_to "/api/done/no-promotion.json"
      end
    end

    context "for draft content" do
      setup do
        content_api_and_content_store_have_unpublished_page("done/no-promotion", 3, @artefact)
      end

      should "does not set the cache expiry headers" do
        get :show, slug: "done/no-promotion", edition: 3

        assert_nil response.headers["Cache-Control"]
      end
    end
  end
end
