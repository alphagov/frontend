RSpec.describe Manual do
  let(:content_store_response) { GovukSchemas::Example.find("manual", example_name: "content-design") }

  it_behaves_like "it can have section groups", "manual", "content-design"
  it_behaves_like "it has no updates", "manual", "content-design"
  it_behaves_like "it can have manual updates", "manual", "content-design"

  describe "#contributors" do
    it "returns the organisations" do
      content_item = described_class.new(content_store_response)

      organisations = content_store_response["links"]["organisations"]
      expect(content_item.contributors.count).to eq(1)
      expect(content_item.contributors[0].title).to eq(organisations[0]["title"])
    end
  end
end
