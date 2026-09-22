RSpec.shared_examples "it can present ordered featured documents" do |document_type, example_name|
  let(:content_store_response) { GovukSchemas::Example.find(document_type, example_name:) }
  let(:content_item) { ContentItemFactory.build(content_store_response) }
  let(:presenter) { described_class.new(content_item) }

  describe "#ordered_featured_documents_for_image_cards" do
    it "maps the ordered featured documents in the content item to a suitable format" do
      expect(presenter.ordered_featured_documents_for_image_cards.count).to eq(content_store_response["details"]["ordered_featured_documents"].count)
      expect(presenter.ordered_featured_documents_for_image_cards[0].keys).to eq(%i[description heading_level heading_text href image_alt image_src margin_bottom])
    end
  end
end
