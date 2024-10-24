RSpec.describe FullPathFormatRoutingConstraint do
  include ContentStoreHelpers

  describe "#matches?" do
    context "when the content_store returns a document" do
      let(:format) { "foo" }
      let(:request) { double(path: "/format/routing/test", env: {}) }

      before do
        stub_content_store_has_item("/format/routing/test", schema_name: format)
      end

      it "returns true if format matches" do
        expect(described_class.new(format).matches?(request)).to be true
      end

      it "returns false if format doesn't match" do
        expect(described_class.new("not_the_format").matches?(request)).to be false
      end

      it "sets the content item on the request object" do
        described_class.new(format).matches?(request)

        expect(request.env[:content_item].present?).to be true
      end
    end

    context "when the content_store API call throws an error" do
      let(:request) { double(path: "/format/routing/test", env: {}) }

      before do
        stub_content_store_does_not_have_item("/format/routing/test")
      end

      it "returns false" do
        expect(described_class.new("any_format").matches?(request)).to be false
      end

      it "sets an error on the request object" do
        described_class.new("any_format").matches?(request)
        expect(request.env[:content_item_error].present?).to be true
      end
    end
  end
end
