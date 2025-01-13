RSpec.describe Place do
  let(:content_store_response) do
    GovukSchemas::Example.find("place", example_name: "find-regional-passport-office")
  end

  describe "#introduction" do
    it "gets the introduction from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.introduction).to eq(content_store_response["details"]["introduction"])
    end
  end

  describe "#more_information" do
    it "gets more_information from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.more_information).to eq(content_store_response["details"]["more_information"])
    end
  end

  describe "#need_to_know" do
    it "gets need_to_know from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.need_to_know).to eq(content_store_response["details"]["need_to_know"])
    end
  end

  describe "#place_type" do
    it "gets the place_type from the content store response" do
      content_item = described_class.new(content_store_response)
      expect(content_item.place_type).to eq(content_store_response["details"]["place_type"])
    end
  end
end
