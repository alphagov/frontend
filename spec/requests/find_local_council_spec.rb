require "gds_api/test_helpers/local_links_manager"

RSpec.describe "Find Local Council" do
  include GdsApi::TestHelpers::LocalLinksManager

  before { content_store_has_random_item(base_path: "/find-local-council") }

  it "sets correct expiry headers" do
    get "/find-local-council"

    expect(response).to honour_content_store_ttl
  end

  it "returns a 404 if the local authority can't be found" do
    stub_local_links_manager_does_not_have_an_authority("foo")
    get "/find-local-council/foo"

    expect(response).to have_http_status(:not_found)
  end
end
