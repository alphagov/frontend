require 'test_helper'
require 'content_api_error_routing_constraint'

class ContentApiErrorRoutingConstraintTest < ActiveSupport::TestCase
  should "return true if there's a cached error" do
    artefact_retriever = content_api(error: true)
    subject = ContentApiErrorRoutingConstraint.new(artefact_retriever: artefact_retriever)
    assert subject.matches?(request)
  end

  should "return false if there's no error in content API" do
    artefact_retriever = content_api(error: false)
    subject = ContentApiErrorRoutingConstraint.new(artefact_retriever: artefact_retriever)
    assert_equal false, subject.matches?(request)
  end

private

  def request
    stub
  end

  def content_api(error: false)
    stub(set_request: nil, error?: error)
  end
end
