require "test_helper"
require 'gds_api/test_helpers/local_links_manager'

class FindLocalCouncilControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::LocalLinksManager

  should "set correct expiry headers" do
    content_store_has_random_item(base_path: '/find-local-council')

    get :index

    assert_equal "max-age=1800, public", response.headers["Cache-Control"]
  end

  should "return a 404 if the local authority can't be found" do
    content_store_has_random_item(base_path: '/find-local-council')
    local_links_manager_does_not_have_an_authority('foo')

    get :result, params: { authority_slug: 'foo' }

    assert_equal 404, response.status
  end
end
