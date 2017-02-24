require "test_helper"

class CompletedTransactionControllerTest < ActionController::TestCase
  setup do
    @payload = {
      base_path: "/done/no-promotion",
      schema_name: "completed_transaction",
      external_related_links: []
    }
  end

  context "GET show" do
    context "for live content" do
      setup do
        content_store_has_item('/done/no-promotion', @payload)
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
  end
end
