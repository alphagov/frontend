require "test_helper"

class TransactionControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "GET show" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item("/foo", schema: "transaction")
      end

      should "set the cache expiry headers" do
        get :show, params: { slug: "foo" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    should "not allow framing of transaction pages" do
      content_store_has_example_item("/foo", schema: "transaction")

      get :show, params: { slug: "foo" }
      assert_equal "DENY", @response.headers["X-Frame-Options"]
    end
  end

  context "loading the jobsearch page" do
    setup do
      @content_item = content_store_has_example_item("/jobsearch", schema: "transaction", example: "jobsearch")
    end

    should "respond with success" do
      get :show, params: { slug: "jobsearch" }
      assert_response :success
    end

    should "loads the correct details" do
      get :show, params: { slug: "jobsearch" }
      assert_equal @content_item["title"], assigns(:publication).title
    end

    should "set correct expiry headers" do
      get :show, params: { slug: "jobsearch" }
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end

  context "given a welsh version exists" do
    setup do
      content_store_has_example_item("/chwilio-am-swydd", schema: "transaction", example: "chwilio-am-swydd")
    end

    should "set the locale to welsh" do
      I18n.expects(:locale=).with(:en)
      I18n.expects(:locale=).with("cy")
      get :show, params: { slug: "chwilio-am-swydd" }
    end
  end

  context "given a variant exists" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item("/foo", schema: "transaction", example: "transaction-with-variants")
      end

      should "display variant specific values where present" do
        get :show, params: { slug: "foo", variant: "council-tax-bands-2-staging" }

        assert_equal @content_item.dig("details", "variants", 0, "title"), assigns(:publication).title
        assert_equal @content_item.dig("details", "variants", 0, "transaction_start_link"), assigns(:publication).transaction_start_link
      end

      should "display normal value where variant does not specify value" do
        get :show, params: { slug: "foo", variant: "council-tax-bands-2-staging" }

        assert_equal @content_item.dig("details", "more_information"), assigns(:publication).more_information
      end
    end
  end
end
