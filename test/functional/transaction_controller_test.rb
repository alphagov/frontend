require "test_helper"

class TransactionControllerTest < ActionController::TestCase
  include EducationNavigationAbTestHelper

  context "GET show" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item('/foo', schema: 'transaction')
      end

      should "set the cache expiry headers" do
        get :show, slug: "foo"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    should "not allow framing of transaction pages" do
      content_store_has_example_item('/foo', schema: 'transaction')

      get :show, slug: 'foo'
      assert_equal "DENY", @response.headers["X-Frame-Options"]
    end

    context "A/B testing" do
      setup do
        content_store_has_example_item('/tagged', schema: 'transaction', is_tagged_to_taxon: true)
        content_store_has_example_item('/not-tagged', schema: 'transaction')
      end

      %w[A B].each do |variant|
        should "not affect non-education pages with the #{variant} variant" do
          setup_ab_variant('EducationNavigation', variant)
          expect_normal_navigation
          get :show, slug: "not-tagged"
          assert_response_not_modified_for_ab_test('EducationNavigation')
        end
      end

      should "show normal breadcrumbs by default" do
        expect_normal_navigation
        get :show, slug: "not-tagged"
      end

      should "show normal breadcrumbs for the 'A' version" do
        expect_normal_navigation
        with_variant EducationNavigation: "A" do
          get :show, slug: "tagged"
        end
      end

      should "show taxon breadcrumbs for the 'B' version" do
        expect_new_navigation
        with_variant EducationNavigation: "B" do
          get :show, slug: "tagged"
        end
      end
    end

    context "tasklist header A/B testing" do
      setup do
        content_store_has_example_item('/learn-to-drive-miss-daisy', schema: 'transaction')
        content_store_has_example_item('/i-have-a-need-a-need-for-speed', schema: 'transaction')

        @controller.stubs(:tasklist_header_ab_test_applies?).returns(true)
      end

      should "not show the tasklist header by default" do
        with_variant TaskListHeader: "A" do
          get :show, slug: "learn-to-drive-miss-daisy"

          assert_template partial: "_tasklist_header", count: 0
        end
      end

      should "show the tasklist header for the 'B' version" do
        with_variant TaskListHeader: "B" do
          get :show, slug: "learn-to-drive-miss-daisy"

          assert_template partial: "_tasklist_header", count: 1
        end
      end
    end

    context "tasklist A/B testing" do
      setup do
        content_store_has_example_item('/learn-to-drive-miss-daisy', schema: 'transaction')
        content_store_has_example_item('/i-have-a-need-a-need-for-speed', schema: 'transaction')

        @controller.stubs(:tasklist_ab_test_applies?).returns(true)
      end

      %w[A B].each do |variant|
        should "variant #{variant} should not affect pages that are not in the test" do
          @controller.stubs(:tasklist_ab_test_applies?).returns(false)

          setup_ab_variant('TaskListSidebar', variant)

          get :show, slug: "learn-to-drive-miss-daisy"
          assert_response_not_modified_for_ab_test('TaskListSidebar')
        end
      end

      should "not show the tasklist sidebar by default" do
        with_variant TaskListSidebar: "A" do
          get :show, slug: "learn-to-drive-miss-daisy"

          assert_template partial: "_tasklist_sidebar", count: 0
        end
      end

      should "show the tasklist sidebar for the 'B' version" do
        with_variant TaskListSidebar: "B" do
          get :show, slug: "learn-to-drive-miss-daisy"

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
      get :jobsearch, slug: "jobsearch"
      assert_response :success
    end

    should "loads the correct details" do
      get :jobsearch, slug: "jobsearch"
      assert_equal @content_item['title'], assigns(:publication).title
    end

    should "set correct expiry headers" do
      get :jobsearch, slug: "jobsearch"
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end

    should "render the jobsearch view" do
      get :jobsearch, slug: "jobsearch"
      assert_template "jobsearch"
    end
  end

  context "given a welsh version exists" do
    setup do
      content_store_has_example_item('/chwilio-am-swydd', schema: 'transaction', example: 'chwilio-am-swydd')
    end

    should "set the locale to welsh" do
      I18n.expects(:locale=).with("cy")
      get :jobsearch, slug: "chwilio-am-swydd"
    end

    should "render the jobsearch view" do
      get :jobsearch, slug: "chwilio-am-swydd"
      assert_template "jobsearch"
    end
  end
end
