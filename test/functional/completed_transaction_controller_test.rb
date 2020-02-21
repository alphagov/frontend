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

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end
  end

  context "A/B testing" do
    setup do
      content_store_has_example_item("/done/vehicle-tax", schema: "completed_transaction")
      content_store_has_example_item("/done/weee", schema: "completed_transaction")
    end

    %w[A B C D E F G H Z].each do |variant|
      should "show the #{variant} variant of the electric car AB test on applicable pages" do
        with_variant ElectricCarABTest: variant do
          get :show, params: { slug: "done/vehicle-tax" }
        end
      end
    end

    should "not use AB testing headers for pages that are not in scope" do
      get :show, params: { slug: "done/weee" }
      assert_response_not_modified_for_ab_test("ElectricCar")
    end
  end
end
