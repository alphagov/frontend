RSpec.describe ApiErrorRoutingConstraint do
  include ContentStoreHelpers

  subject(:api_error_routing_constraint) { described_class.new }

  let(:request) { instance_double(ActionDispatch::Request, path: "/slug", env: {}) }

  it "returns true if there's a cached error" do
    stub_content_store_does_not_have_item("/slug")

    expect(api_error_routing_constraint.matches?(request)).to be true
  end

  it "returns false if there was no error in API calls" do
    stub_content_store_has_item("/slug")

    expect(api_error_routing_constraint.matches?(request)).to be false
  end
end
