RSpec.describe FormatRoutingConstraint do
  include ContentStoreHelpers

  describe "#matches?" do
    let(:request) { instance_double(ActionDispatch::Request, path: "/slug", params: { slug: "slug" }, env: {}, headers: {}) }

    context "when the content_store returns a document" do
      before do
        stub_conditional_loader_returns_content_item_for_path("/slug", schema_name: "foo")
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
        stub_conditional_loader_does_not_return_content_item_for_path("/slug")
      end

      it "returns false" do
        expect(described_class.new("any_format").matches?(request)).to be false
      end
    end
  end
end
