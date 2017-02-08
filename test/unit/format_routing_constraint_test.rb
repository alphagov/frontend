require 'test_helper'

class FormatRoutingConstraintTest < ActiveSupport::TestCase
  context "#matches?" do
    context "when the content_store returns a document" do
      setup do
        @format = "foo"
        @inspector = stub(new: stub(format: @format, error: nil))
      end

      should "return true if format matches" do
        assert subject(@format, @inspector).matches?(request)
      end

      should "return false if format doesn't match" do
        assert_not subject("not_the_format", @inspector).matches?(request)
      end
    end

    context "when the content_store API call throws an error" do
      setup do
        @error = GdsApi::HTTPNotFound.new(404)
        @inspector = stub(new: stub(format: nil, error: @error))
        @request = request
      end

      should "return false" do
        assert_not subject("foo", @inspector).matches?(@request)
      end

      should "set an error on the request object" do
        subject("foo", @inspector).matches?(@request)
        assert @request.env[:__api_error] == @error
      end
    end
  end

  context "instances are memoized and used across multiple requests" do
    setup do
      @api_proxy = stub
      @format = "static across requests"
      @content_format_inspector_instance = stub(format: @format, error: nil)
      @subject = subject("foo", @api_proxy)
    end

    should "make new API calls each time" do
      @api_proxy.expects(:new).twice.returns(@content_format_inspector_instance)
      @subject.matches?(request)
      @subject.matches?(request)
    end
  end

  context "a request will be passed to multiple instances" do
    setup do
      @api_proxy = stub
      @inspector_instance = stub(format: "baz", error: nil)
      @request = request
    end

    should "not make additional API calls" do
      @api_proxy.expects(:new).once.returns(@inspector_instance)
      subject("foo", @api_proxy).matches?(@request)
      subject("bar", @api_proxy).matches?(@request)
    end
  end

  def request
    env = {}
    stub(params: { slug: 'test_slug' }, env: env)
  end

  def subject(format, content_format_inspector)
    FormatRoutingConstraint.new(format, content_format_inspector: content_format_inspector)
  end
end
