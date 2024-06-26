RSpec.describe FormatRoutingConstraint, type: :model do
  include ContentStoreHelpers

  describe "#matches?" do
    context "when the content_store returns a document" do
      before do
        @format = "foo"
        stub_content_store_has_item("/#{slug}", schema_name: @format)
        @request = request
      end

      it "returns true if format matches" do
        expect(subject(@format).matches?(@request)).to be true
      end

      it "returns false if format doesn't match" do
        expect(subject("not_the_format").matches?(@request)).to be false
      end

      it "sets the content item on the request object" do
        subject(@format).matches?(@request)

        expect(@request.env[:content_item].present?).to be true
      end
    end

    context "when the content_store API call throws an error" do
      before do
        stub_content_store_does_not_have_item("/#{slug}")
        @request = request
      end

      it "returns false" do
        expect(subject("any_format").matches?(@request)).to be false
      end

      it "sets an error on the request object" do
        subject("any_format").matches?(@request)
        expect(@request.env[:content_item_error].present?).to be true
      end
    end
  end

  context "content items are memoized and used across multiple requests" do
    before do
      @stub = stub_content_store_has_item("/#{slug}", schema_name: "foo")
      @subject = subject("foo")
      @request = request
    end

    it "only makes one API call" do
      @subject.matches?(@request)
      @subject.matches?(@request)

      assert_requested(@stub, times: 1)
    end
  end

  def slug
    "test_slug"
  end

  def request
    double(params: { slug: }, env: {})
  end

  def subject(format)
    FormatRoutingConstraint.new(format)
  end
end
