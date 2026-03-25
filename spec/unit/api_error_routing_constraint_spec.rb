RSpec.describe ApiErrorRoutingConstraint do
  include ContentStoreHelpers

  subject(:api_error_routing_constraint) { described_class.new }

  let(:request) { instance_double(ActionDispatch::Request, path: "/slug", env: {}, headers: {}, params: {}) }

  it "returns true if there's a cached error" do
    stub_conditional_loader_does_not_return_content_item_for_path("/slug")

    expect(api_error_routing_constraint.matches?(request)).to be true
  end

  it "returns false if there was no error in API calls" do
    stub_conditional_loader_returns_content_item_for_path("/slug")

    expect(api_error_routing_constraint.matches?(request)).to be false
  end
end
