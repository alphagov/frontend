require "api_error_routing_constraint"

RSpec.describe ApiErrorRoutingConstraint, type: :model do
  it "returns true if there's a cached error" do
    request = double(env: { content_item_error: StandardError.new })

    expect(subject.matches?(request)).to be true
  end

  it "returns false if there was no error in API calls" do
    request = double(env: {})

    expect(subject.matches?(request)).to be false
  end

private

  def subject
    ApiErrorRoutingConstraint.new
  end
end
