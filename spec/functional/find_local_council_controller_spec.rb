require "gds_api/test_helpers/local_links_manager"

RSpec.describe FindLocalCouncilController, type: :controller do
  include GdsApi::TestHelpers::LocalLinksManager

  before { content_store_has_random_item(base_path: "/find-local-council") }

  it "sets correct expiry headers" do
    get(:index)

    honours_content_store_ttl
  end

  it "returns a 404 if the local authority can't be found" do
    stub_local_links_manager_does_not_have_an_authority("foo")
    get(:result, params: { authority_slug: "foo" })

    expect(response.status).to eq(404)
  end
end
