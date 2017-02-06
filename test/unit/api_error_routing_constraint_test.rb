require 'test_helper'
require 'api_error_routing_constraint'

class ApiErrorRoutingConstraintTest < ActiveSupport::TestCase
  should "return true if there's a cached error" do
    request = stub(env: { __api_error: StandardError.new })
    assert subject.matches?(request)
  end

  should "return false if there's no error in content API" do
    request = stub(env: {})
    assert_equal false, subject.matches?(request)
  end

private

  def subject
    ApiErrorRoutingConstraint.new
  end

  def content_api(error: false)
    stub(set_request: nil, error?: error)
  end
end
