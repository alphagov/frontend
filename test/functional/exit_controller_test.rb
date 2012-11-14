require "test_helper"

class ExitControllerTest < ActionController::TestCase

  def mock_content_api(slug, publication)
    artefact = artefact_for_slug(slug).merge(publication)
    content_api_has_an_artefact(slug, artefact)
  end

  context 'transaciton exit page tracking' do

    should "redirect for link in details.link of transaction" do
      slug = 'council-housing'
      need_id = '999999'
      format = "transaction"

      target = 'http://example.com'

      mock_content_api(slug, { :format => format, details: { :link => target} } )

      get :exit, slug: slug, format: format

      assert_redirected_to target
    end

    should "return 404 if content api throws a RecordNotFound Error" do
      slug = 'tax-disc-license'
      need_id = '999999'
      format = 'transaction'

      content_api_does_not_have_an_artefact(slug)
      get :exit, slug: slug, format: format

      assert_equal 404, response.status
    end

    should "return 404 if details is missing in publication" do
      slug = 'council-housing'
      need_id = '999999'
      format = "transaction"

      mock_content_api(slug, { :format => format } )

      get :exit, slug: slug, format: format

      assert_equal 404, response.status
    end

    should "return 404 if details.link is missing in publication" do
      slug = 'council-housing'
      need_id = '999999'
      format = "transaction"

      mock_content_api(slug, { :format => format, :details => {} } )

      get :exit, slug: slug, format: format

      assert_equal 404, response.status
    end

    should "return 404 if format is not transaction from url params" do
      slug = '/tax-disc-license'
      need_id = '999999'
      format = 'ABC'

      get :exit, slug: slug, format: format

      assert_equal 404, response.status
    end

    should "return 404 if format is missing from url params" do
      slug = '/tax-disc-license'
      need_id = '999999'

      get :exit, slug: slug

      assert_equal 404, response.status
    end

    should "return 404 if slug is missing from url params" do
      need_id = '999999'
      format = 'transaction'

      get :exit, format: format

      assert_equal 404, response.status
    end
  end
end