require "test_helper"
require "api_error_routing_constraint"

class ApiErrorRoutingConstraintTest < ActiveSupport::TestCase
  should "return true if there's a cached error" do
    request = stub(env: { content_item_error: StandardError.new })
    assert subject.matches?(request)
  end

  should "return false if there was no error in API calls" do
    request = stub(env: {})
    assert_equal false, subject.matches?(request)
  end

private

  def subject
    ApiErrorRoutingConstraint.new
  end
end
