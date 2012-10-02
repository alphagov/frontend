require "test_helper"

class ExitControllerTest < ActionController::TestCase

  def mock_publications_api(slug, publication)
    api = mock()
    api.expects(:publication_for_slug).with(slug, {}).returns(OpenStruct.new(publication))
    @controller.stubs(:publisher_api).returns(api)
  end

  context 'exit page tracking' do
    context 'transaction format' do
      should "render exit html" do
        slug = '/tax-disc-license'
        target = 'http://google.com'
        need_id = '999999'
        type = "transaction"

        mock_publications_api(slug, {:type => type, :link => target})

        get :exit, slug: slug, target: target, needId: need_id

        assert_redirected_to target
      end

      should "return 404 if slug does not exist" do
        slug = 'tax-disc-license234'
        target = 'http://www.naughty_website.com'
        need_id = '999999'

        api = mock()
        api.expects(:publication_for_slug).with(slug, {}).returns(nil)
        @controller.stubs(:publisher_api).returns(api)

        get :exit, slug: slug, target: target, needId: need_id

        assert_equal 404, response.status
      end

      should "return 403 if the target is not included publication" do
        slug = 'tax-disc-license'
        target = 'http://www.naughty_website.com'
        need_id = '999999'

        mock_publications_api(slug, {:type => "transaction", :link => "http://nice-guys-inc.com", :more_information => ""})

        get :exit, slug: slug, target: target, needId: need_id

        assert_equal 403, response.status
      end
    end

    context 'guide format' do

      should "render exit html for guide" do
        slug = 'council-housing'
        target = 'http://example.com'
        need_id = '999999'
        type = "guide"

        mock_publications_api(slug, {:type => type, :parts => [OpenStruct.new(:body => 'Go here [local councils](http://example.com "Find your local council")  ')]})

        get :exit, slug: slug, target: target, needId: need_id

        assert_redirected_to target

      end

      should "return 403 if the target is not included publication" do
        slug = 'tax-disc-license'
        target = 'http://www.naughty_website.com'
        need_id = '999999'
        type = "guide"

        mock_publications_api(slug, {:type => type, :parts => [OpenStruct.new(:body => "akdsjfhaksd aksdjfhkasd")]})

        get :exit, slug: slug, target: target, needId: need_id

        assert_equal 403, response.status
      end

    end


    should "return 404 if the publication type is not supported" do
      slug = '/tax-disc-license'
      target = 'http://www.naughty_website.com'
      need_id = '999999'

      mock_publications_api(slug, {:type => 'pickles'})

      get :exit, slug: slug, target: target, needId: need_id

      assert_equal 404, response.status
    end

    should "return 404 if target is missing from url params" do
      slug = '/tax-disc-license'
      needId = '999999'

      get :exit, slug: slug, needId: needId

      assert_equal 404, response.status
    end

    should "return 404 if needId is missing from url params" do
      slug = '/tax-disc-license'
      target = 'http://www.naughty_website.com'

      get :exit, slug: slug, target: target

      assert_equal 404, response.status
    end

    should "return 404 if slug is missing from url params" do
      target = 'http://www.naughty_website.com'
      needId = '999999'

      get :exit, target: target, needId: needId

      assert_equal 404, response.status
    end
  end
end