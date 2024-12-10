RSpec.describe Place do
  before do
    @content_store_response = GovukSchemas::Example.find("place", example_name: "find-regional-passport-office")
  end

  describe "#introduction" do
    it "shows the introduction" do
      @content_store_response["details"]["introduction"] = "foo"
      expect(described_class.new(@content_store_response).introduction).to eq("foo")
    end
  end

  describe "#more_information" do
    it "shows the more_information" do
      @content_store_response["details"]["more_information"] = "foo"
      expect(described_class.new(@content_store_response).more_information).to eq("foo")
    end
  end

  describe "#need_to_know" do
    it "shows the need to know" do
      @content_store_response["details"]["need_to_know"] = "foo"
      expect(described_class.new(@content_store_response).need_to_know).to eq("foo")
    end
  end

  describe "#place_type" do
    it "shows the place_type" do
      @content_store_response["details"]["place_type"] = "foo"
      expect(described_class.new(@content_store_response).place_type).to eq("foo")
    end
  end
end
