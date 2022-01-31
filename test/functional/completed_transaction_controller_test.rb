require "test_helper"

class CompletedTransactionControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  setup do
    @payload = {
      base_path: "/done/no-promotion",
      schema_name: "completed_transaction",
      document_type: "completed_transaction",
    }
  end

  context "GET show" do
    context "for live content" do
      setup do
        stub_content_store_has_item("/done/no-promotion", @payload)
      end

      should "set the cache expiry headers" do
        get :show, params: { slug: "done/no-promotion" }

        honours_content_store_ttl
      end
    end
  end
end
