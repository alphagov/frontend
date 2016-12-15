require 'test_helper'

class FormatRoutingConstraintTest < ActiveSupport::TestCase
  should "return true if format matches" do
    assert subject('foo', artefact('foo'))
      .matches?(request)
  end

  should "return false if format fails to match" do
    assert_not subject('foo', artefact('bar'))
      .matches?(request)
  end

  should "return false if no artefact found for given slug" do
    assert_not subject('foo', false)
      .matches?(request)
  end

  def request
    stub(params: { slug: 'test_slug' })
  end

  def artefact(format)
    stub(:[] => format)
  end

  def artefact_retriever(artefact)
    stub(set_request: true, fetch_artefact: artefact)
  end

  def subject(format, artefact)
    artefact_retriever = artefact_retriever(artefact)
    FormatRoutingConstraint.new(format, artefact_retriever: artefact_retriever)
  end
end
