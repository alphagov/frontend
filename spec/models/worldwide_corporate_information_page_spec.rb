RSpec.describe WorldwideCorporateInformationPage do
  let(:content_store_response) { GovukSchemas::Example.find("worldwide_corporate_information_page", example_name: "worldwide_corporate_information_page") }

  let(:content_item) { described_class.new(content_store_response) }

  describe "#headers" do
    context "when there are headers in the details hash" do
      it "returns the headers" do
        expect(content_item.headers).to eq(content_store_response.dig("details", "headers"))
      end
    end

    context "when there are no headers in the details hash" do
      it "returns an empty array" do
        content_store_response["details"].delete("headers")

        expect(content_item.headers).to eq([])
      end
    end
  end

  describe "#worldwide_organisation" do
    it "returns the first worldwide organisation" do
      expect(content_item.worldwide_organisation.content_store_response).to eq(content_store_response.dig("links", "worldwide_organisation", 0))
    end
  end
end
