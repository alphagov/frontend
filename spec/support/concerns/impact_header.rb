RSpec.shared_examples "it can present an impact header" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:content_item) { ContentItemFactory.build(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#impact_header_options" do
    it "includes the page title in the heading" do
      expect(presenter.impact_header_options[:heading]).to eq(content_store_response["title"])
    end

    it "includes the page description in the description" do
      expect(presenter.impact_header_options[:description]).to eq(content_store_response["description"])
    end

    it "returns image information" do
      expect(presenter.impact_header_options[:image]).not_to be_empty
    end

    it "returns a plain variant" do
      expect(presenter.impact_header_options[:variant]).to eq("plain")
    end

    context "when the content item for the presenter is tagged to notable-death" do
      let(:content_store_response) do
        GovukSchemas::Example.find(document_type, example_name:).tap do |item|
          item["links"]["taxons"] = [{ "base_path" => "/society-and-culture/notable-death" }]
        end
      end

      it "returns a noteable-death variant" do
        expect(presenter.impact_header_options[:variant]).to eq("notable-death")
      end
    end
  end
end
