RSpec.describe "Landing Pages" do
  include ContentStoreHelpers

  before do
    stub_content_store_has_item("/routing/constraint/test", schema_name: "landing_page")
  end

  it "routes to the LandingPage controller" do
    expect(get("/routing/constraint/test")).to route_to(controller: "landing_page", action: "show", path: "routing/constraint/test")
  end
end
