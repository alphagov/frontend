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

  context "loading the legacy transaction finished page" do
    context "given an artefact for 'transaction-finished' exists" do
      setup do
        @details = {
          'slug' => 'transaction-finished',
          'web_url' => 'https://www.preview.alphagov.co.uk/transaction-finished',
          'format' => 'completed_transaction'
        }
        content_api_and_content_store_have_page('transaction-finished', @details)
      end

      should "respond with success" do
        get :show, slug: "transaction-finished"
        assert_response :success
      end

      should "load the correct details" do
        get :show, slug: "transaction-finished"
        url = "https://www.preview.alphagov.co.uk/transaction-finished"
        assert_equal url, assigns(:publication).web_url
      end

      should "render the legacy completed transaction view" do
        get :show, slug: "transaction-finished"
        assert_template "legacy_completed_transaction"
      end
    end
  end
end
