RSpec.describe Guide do
  subject(:guide) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }

  it_behaves_like "it has parts", "guide", "guide"

  describe "#is_evisa?" do
    it "returns false" do
      expect(guide.is_evisa?).to be false
    end

    context "when the base_path is /evisa" do
      let(:content_store_response) do
        GovukSchemas::Example.find("guide", example_name: "guide").tap { |i| i.merge!("base_path" => "/evisa") }
      end

      it "returns true" do
        expect(guide.is_evisa?).to be true
      end
    end
  end
end
