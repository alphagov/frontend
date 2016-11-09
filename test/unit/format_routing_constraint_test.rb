require 'test_helper'

class FormatRoutingConstraintTest < ActiveSupport::TestCase
  context "content-api returns an artefact" do
    setup do
      @format = 'foo'
      @artefact = stub(format: @format)
      @artefact_retriever = stub(fetch_artefact: @artefact)
      @env = {}
      @slug = 'our_test_slug'
      @request = stub(params: { slug: @slug }, env: @env)
    end

    should "return true if format matches" do
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      assert subject.matches?(@request)
    end

    should "return false if format fails to match" do
      subject = FormatRoutingConstraint.new('unmatched', artefact_retriever: @artefact_retriever)
      assert_not subject.matches?(@request)
    end

    should "cache the result of the call to content-api" do
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      subject.matches?(@request)
      assert_equal @env, __artefact_cache: { @slug => @artefact }
    end

    should "not call the API twice for the same slug" do
      FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever).matches?(@request)
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      @artefact_retriever.expects(:fetch_artefact).never
      assert subject.matches?(@request)
    end

    should "re-call the API if the slug changes" do
      FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever).matches?(@request)
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      @artefact_retriever.expects(:fetch_artefact)
      subject.matches?(stub(params: { slug: 'new_slug' }, env: @env))
    end
  end

  context "bad result from the content-api" do
    setup do
      @format = 'foo'
      @artefact_retriever = stub(fetch_artefact: :bar)
      @request = stub(params: { slug: 'baz' }, env: {})
    end

    should "return nil when the content-api returns nothing" do
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      assert_nil subject.matches?(@request)
    end

    should "return nil when the content-api adaptor explodes" do
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      @artefact_retriever
        .expects(:fetch_artefact)
        .raises(StandardError)
      assert_nil subject.matches?(@request)
    end

    should "return false when the returned object doesnt respond to #format" do
      subject = FormatRoutingConstraint.new(@format, artefact_retriever: @artefact_retriever)
      @artefact_retriever
        .expects(:fetch_artefact)
        .returns(stub)
      assert_not subject.matches?(@request)
    end
  end
end
