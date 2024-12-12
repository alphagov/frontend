RSpec.describe SimpleSmartAnswer do
  describe "#slug" do
    it "returns the subject slug" do
      content_store_response = GovukSchemas::Example.find("simple_smart_answer", example_name: "simple-smart-answer")
      content_store_response["base_path"] = "/foo"
      expect(described_class.new(content_store_response).slug).to eq("foo")
    end
  end
end
