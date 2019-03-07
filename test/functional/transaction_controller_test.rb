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

    should "get item from the content store and keeps ordered_related_items when running RelatedLinksABTest3 control variant" do
      with_variant RelatedLinksABTest3: 'A' do
        @content_item = content_store_has_example_item('/apply-marine-licence', schema: 'transaction', example: 'apply-marine-licence')

        get :show, params: { slug: 'apply-marine-licence' }

        assert_response :success
        assert_equal @content_item['links']['ordered_related_items'], assigns[:content_item]['links']['ordered_related_items']
      end
    end

    should "get item from the content store and replace ordered_related_items when running RelatedLinksABTest3 test variant" do
      with_variant RelatedLinksABTest3: 'B' do
        @content_item = content_store_has_example_item('/apply-marine-licence', schema: 'transaction', example: 'apply-marine-licence')

        get :show, params: { slug: 'apply-marine-licence' }

        assert_response :success
        assert_equal assigns[:content_item]['links']['ordered_related_items'], assigns[:content_item]['links']['suggested_ordered_related_items']
      end
    end

    should "get item from the content store and replace ordered_related_items with empty array when running RelatedLinksABTest3 test variant" do
      with_variant RelatedLinksABTest3: 'B' do
        @content_item = content_store_has_example_item('/national-curriculum', schema: 'guide', example: 'guide')

        get :show, params: { slug: 'national-curriculum' }

        assert_response :success
        assert_equal [], assigns[:content_item]['links']['ordered_related_items']
      end
    end
  end

  context "loading the jobsearch page" do
    setup do
      @content_item = content_store_has_example_item('/jobsearch', schema: 'transaction', example: 'jobsearch')
    end

    should "respond with success" do
      get :show, params: { slug: "jobsearch" }
      assert_response :success
    end

    should "loads the correct details" do
      get :show, params: { slug: "jobsearch" }
      assert_equal @content_item['title'], assigns(:publication).title
    end

    should "set correct expiry headers" do
      get :show, params: { slug: "jobsearch" }
      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end

  context "given a welsh version exists" do
    setup do
      content_store_has_example_item('/chwilio-am-swydd', schema: 'transaction', example: 'chwilio-am-swydd')
    end

    should "set the locale to welsh" do
      I18n.expects(:locale=).with("cy")
      get :show, params: { slug: "chwilio-am-swydd" }
    end
  end

  context "given a variant exists" do
    context "for live content" do
      setup do
        @content_item = content_store_has_example_item('/foo', schema: 'transaction', example: 'transaction-with-variants')
      end

      should "display variant specific values where present" do
        get :show, params: { slug: "foo", variant: "council-tax-bands-2-staging" }

        assert_equal @content_item.dig('details', 'variants', 0, 'title'), assigns(:publication).title
        assert_equal @content_item.dig('details', 'variants', 0, 'transaction_start_link'), assigns(:publication).transaction_start_link
      end

      should "display normal value where variant does not specify value" do
        get :show, params: { slug: "foo", variant: "council-tax-bands-2-staging" }

        assert_equal @content_item.dig('details', 'more_information'), assigns(:publication).more_information
      end
    end
  end
end
