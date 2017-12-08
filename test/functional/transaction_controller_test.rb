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

    context "tasklist header A/B testing" do
      setup do
        content_store_has_example_item('/vehicles-can-drive', schema: 'transaction')
        content_store_has_example_item('/not-in-test', schema: 'transaction')
      end

      %w[A B].each do |variant|
        should "variant #{variant} should not show the tasklist header on pages that are not in the test" do
          setup_ab_variant('TaskListHeader', variant)

          get :show, params: { slug: 'not-in-test' }
          assert_response_not_modified_for_ab_test('TaskListHeader')
        end
      end

      should "not show the tasklist header by default" do
        with_variant TaskListHeader: "A" do
          get :show, params: { slug: "vehicles-can-drive" }

          assert_template partial: "_tasklist_header", count: 0
        end
      end

      should "show the tasklist header for the 'B' version" do
        with_variant TaskListHeader: "B" do
          get :show, params: { slug: "vehicles-can-drive" }

          assert_template partial: "_tasklist_header", count: 1
        end
      end
    end

    context "tasklist A/B testing" do
      setup do
        content_store_has_example_item('/vehicles-can-drive', schema: 'transaction')
        content_store_has_example_item('/not-in-test', schema: 'transaction')
      end

      %w[A B].each do |variant|
        should "variant #{variant} should not affect pages that are not in the test" do
          setup_ab_variant('TaskListSidebar', variant)

          get :show, params: { slug: "not-in-test" }
          assert_response_not_modified_for_ab_test('TaskListSidebar')
        end
      end

      should "not show the tasklist sidebar by default" do
        with_variant TaskListSidebar: "A" do
          get :show, params: { slug: "vehicles-can-drive" }

          assert_template partial: "_tasklist_sidebar", count: 0
        end
      end

      should "show the tasklist sidebar for the 'B' version" do
        with_variant TaskListSidebar: "B" do
          get :show, params: { slug: "vehicles-can-drive" }

          assert_template partial: "_tasklist_sidebar", count: 1
        end
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
