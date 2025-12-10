RSpec.describe WorkingGroup do
  subject(:working_group) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "long") }

  describe "#headers" do
    context "when there are headers in the details hash" do
      it "returns a list of headings" do
        expect(working_group.headers).to eq(content_store_response["details"]["headers"])
      end
    end

    context "when there are no headers in the details hash" do
      let(:content_store_response) { GovukSchemas::Example.find("working_group", example_name: "short") }

      it "returns an empty array" do
        expect(working_group.headers).to eq([])
        expect(content_item.headers).to eq([])

      end
    end
  end
end
