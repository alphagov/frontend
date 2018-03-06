require "test_helper"

class TransactionControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  context "GET show" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item('/foo', schema: 'transaction')
      end

      should "set the cache expiry headers" do
        get :show, params: { slug: "foo" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    should "not allow framing of transaction pages" do
      content_store_has_example_item('/foo', schema: 'transaction')

      get :show, params: { slug: 'foo' }
      assert_equal "DENY", @response.headers["X-Frame-Options"]
    end

    context "step navigation header" do
      setup do
        content_store_has_example_item('/vehicles-can-drive', schema: 'transaction', example: "transaction-with-step-navs")
        content_store_has_example_item('/not-in-test', schema: 'transaction', example: "transaction")
      end

      should "should not show the step_nav header on irrelevant pages" do
        get :show, params: { slug: 'not-in-test' }
        assert_template partial: "_step_nav_header", count: 0
      end

      should "show the step_nav header on relevant pages" do
        get :show, params: { slug: "vehicles-can-drive" }
        assert_template partial: "_step_nav_header", count: 1
      end
    end

    context "step navigation" do
      setup do
        content_store_has_example_item('/vehicles-can-drive', schema: 'transaction', example: "transaction-with-step-navs")
        content_store_has_example_item('/not-in-test', schema: 'transaction', example: "transaction")
      end

      should "should not show the step navigation sidebar on irrelevant pages" do
        get :show, params: { slug: "not-in-test" }
        assert_template partial: "_step_nav_sidebar", count: 0
      end

      should "show the step navigation sidebar on relevant pages" do
        get :show, params: { slug: "vehicles-can-drive" }
        assert_template partial: "_step_nav_sidebar", count: 1
      end
    end
  end

  context "loading the jobsearch page" do
    setup do
      @content_item = content_store_has_example_item('/jobsearch', schema: 'transaction', example: 'jobsearch')
    end

    should "respond with success" do
      get :jobsearch, params: { slug: "jobsearch" }
      assert_response :success
    end

    should "loads the correct details" do
      get :jobsearch, params: { slug: "jobsearch" }
      assert_equal @content_item['title'], assigns(:publication).title
    end

    should "set correct expiry headers" do
      get :jobsearch, params: { slug: "jobsearch" }
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "render the jobsearch view" do
      get :jobsearch, params: { slug: "jobsearch" }
      assert_template "jobsearch"
    end
  end

  context "given a welsh version exists" do
    setup do
      content_store_has_example_item('/chwilio-am-swydd', schema: 'transaction', example: 'chwilio-am-swydd')
    end

    should "set the locale to welsh" do
      I18n.expects(:locale=).with("cy")
      get :jobsearch, params: { slug: "chwilio-am-swydd" }
    end

    should "render the jobsearch view" do
      get :jobsearch, params: { slug: "chwilio-am-swydd" }
      assert_template "jobsearch"
    end
  end
end
