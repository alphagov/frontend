require "test_helper"

class FormatRoutingConstraintTest < ActiveSupport::TestCase
  context "#matches?" do
    context "when the content_store returns a document" do
      setup do
        @format = "foo"
        stub_content_store_has_item("/#{slug}", schema_name: @format)
        @request = request
      end

      should "return true if format matches" do
        assert subject(@format).matches?(@request)
      end

      should "return false if format doesn't match" do
        assert_not subject("not_the_format").matches?(@request)
      end

      should "set the content item on the request object" do
        subject(@format).matches?(@request)
        assert @request.env[:content_item].present?
      end
    end

    context "when the content_store API call throws an error" do
      setup do
        stub_content_store_does_not_have_item("/#{slug}")
        @request = request
      end

      should "return false" do
        assert_not subject("any_format").matches?(@request)
      end

      should "set an error on the request object" do
        subject("any_format").matches?(@request)
        assert @request.env[:content_item_error].present?
      end
    end
  end

  context "content items are memoized and used across multiple requests" do
    setup do
      @stub = stub_content_store_has_item("/#{slug}", schema_name: "foo")
      @subject = subject("foo")
      @request = request
    end

    should "only make one API call" do
      @subject.matches?(@request)
      @subject.matches?(@request)
      assert_requested @stub, times: 1
    end
  end

  def slug
    "test_slug"
  end

  def request
    stub(params: { slug: }, env: {})
  end

  def subject(format)
    FormatRoutingConstraint.new(format)
  end
end
