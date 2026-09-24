RSpec.shared_examples "it can present an involved list" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:content_item) { ContentItemFactory.build(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#organisation_data_for_components" do
    it "maps the involved organistions in the content item to a suitable format" do
      expect(presenter.organisation_data_for_components.first.keys).to eq(%i[brand crest image name url])
    end

    context "when an organisation logo inage is present" do
      let(:content_store_response) do
        GovukSchemas::Example.find(document_type, example_name:).tap do |item|
          first_emphasised_org_id = item["details"]["emphasised_organisations"].first
          first_emphasised_org = item["links"]["organisations"].find { |org| org["content_id"] == first_emphasised_org_id }
          first_emphasised_org["details"]["logo"]["image"] = { "alt_text" => "descriptive", "url" => "image.png" }
        end
      end

      it "maps the logo to a suitable format in the image key" do
        expect(presenter.organisation_data_for_components.first[:image]).to eq({ alt_text: "descriptive", url: "image.png" })
      end
    end
  end
end
