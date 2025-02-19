RSpec.describe Organisation do
  let(:content_store_response) do
    GovukSchemas::Example.find("organisation", example_name: "organisation")
  end

  describe "logo" do
    it "gets the crest" do
      expect(described_class.new(content_store_response).logo.crest)
        .to eq(content_store_response.dig("details", "logo", "crest"))
    end

    it "gets the formatted title" do
      expect(described_class.new(content_store_response).logo.formatted_title)
        .to eq(content_store_response.dig("details", "logo", "formatted_title"))
    end
  end
end
