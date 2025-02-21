RSpec.describe Finder do
  describe "#facets" do
    subject(:finder) { described_class.new(finder_content_item) }

    let(:content_store_response) { GovukSchemas::Example.find("specialist_document", example_name: "aaib-reports") }
    let(:finder_content_item) { content_store_response.dig("links", "finder", 0) }

    it "returns a list of modelled facets" do
      expect(finder.facets.count).to eq(finder_content_item.dig("details", "facets").count)
      expect(finder.facets.first["key"]).to eq(finder_content_item.dig("details", "facets", 0, "key"))
    end
  end
end
