RSpec.describe FullPathFormatRoutingConstraint do
  include ContentStoreHelpers

  describe "#matches?" do
    let(:request) { instance_double(ActionDispatch::Request, path: "/format/routing/test", env: {}, headers: {}, params: {}) }

    context "when the content_store returns a document" do
      before do
        stub_content_store_has_item("/format/routing/test", schema_name: "foo")
      end

      it "returns true if format matches" do
        expect(described_class.new("foo").matches?(request)).to be true
      end

      it "returns false if format doesn't match" do
        expect(described_class.new("not_the_format").matches?(request)).to be false
      end
    end

    context "when the content_store API call throws an error" do
      before do
        stub_content_store_does_not_have_item("/format/routing/test")
      end

      it "returns false" do
        expect(described_class.new("any_format").matches?(request)).to be false
      end
    end
  end
end
