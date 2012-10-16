require "test_helper"

class ExitControllerTest < ActionController::TestCase

  def mock_content_api(slug, publication)
    artefact = artefact_for_slug(slug).merge(publication)
    content_api_has_an_artefact(slug, artefact)
  end

  context 'exit page tracking' do

    should "render exit html for guide" do
      slug = 'council-housing'
      target = 'http://example.com'
      need_id = '999999'
      format = "guide"

      mock_content_api(slug, {:format => format, details: { :parts => [ { :link => target } ] } } )

      get :exit, slug: slug, target: target, need_id: need_id

      assert_redirected_to target
    end


    should "redirect for link in body property" do
      slug = 'council-housing'
      target = 'http://example.com'
      need_id = '999999'
      format = "guide"

      mock_content_api(slug, { :format => format, details: { :parts => [ { :body => 'Go here [local councils](http://example.com "Find your local council")  ' } ] } } )

      get :exit, slug: slug, target: target, need_id: need_id

      assert_redirected_to target
    end

    should "redirect for link in details.link of transaction" do
      slug = 'council-housing'
      need_id = '999999'
      target = 'http://example.com'
      format = "transaction"

      mock_content_api(slug, { :format => format, details: { :link => target} } )

      get :exit, slug: slug, need_id: need_id, format: format

      assert_redirected_to target
    end

    should "redirect links for link in link property" do
      slug = '/tax-disc-license'
      target = 'htp://google.com'
      need_id = '999999'
      format = "transaction"

      mock_content_api(slug, { :format => format, :link => target })

      get :exit, slug: slug, target: target, need_id: need_id

      assert_redirected_to target
    end


    should "return 404 if the target is not a valid uri" do
      slug = 'tax-disc-license'
      target = 'www.naughty_website.com'
      need_id = '999999'
      format = "guide"

      get :exit, slug: slug, target: target, need_id: need_id

      assert_equal 404, response.status
    end

    should "return 403 if the target is not included publication" do
      slug = 'tax-disc-license'
      target = 'http://www.naughty_website.com'
      need_id = '999999'
      format = "guide"

      mock_content_api(slug, {:format => format, details: { :parts => [ { :body => "akdsjfhaksd aksdjfhkasd" } ] } } )

      get :exit, slug: slug, target: target, need_id: need_id

      assert_equal 403, response.status
    end

    should "return 404 if content api throws a RecordNotFound Error" do
      slug = 'tax-disc-license'
      target = 'http://www.naughty_website.com'
      need_id = '999999'

      content_api_does_not_have_an_artefact(slug)
      get :exit, slug: slug, target: target, need_id: need_id

      assert_equal 404, response.status
    end

    should "return 404 if target is missing and format is not transaction from url params" do
      slug = '/tax-disc-license'
      need_id = '999999'
      format = 'ABC'

      get :exit, slug: slug, need_id: need_id, format: format

      assert_equal 404, response.status
    end

    should "return 404 if need_id is missing from url params" do
      slug = '/tax-disc-license'
      target = 'http://www.naughty_website.com'

      get :exit, slug: slug, target: target

      assert_equal 404, response.status
    end

    should "return 404 if slug is missing from url params" do
      target = 'http://www.naughty_website.com'
      need_id = '999999'

      get :exit, target: target, need_id: need_id

      assert_equal 404, response.status
    end
  end
end