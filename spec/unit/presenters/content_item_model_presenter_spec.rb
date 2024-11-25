RSpec.describe ContentItemModelPresenter do
  describe "#page_title" do
    before do
      @content_store_response = GovukSchemas::Example.find("detailed_guide", example_name: "withdrawn_detailed_guide")
    end

    it "includes withdrawn in the page title when the content item is withdrawn" do
      content_item = ContentItem.new(@content_store_response)

      expect(described_class.new(content_item).page_title).to include("[Withdrawn]")
      expect(described_class.new(content_item).page_title).to include(content_item.title)
    end

    it "only includes the content item title when the page is not withdrawn" do
      @content_store_response["withdrawn_notice"] = {}
      content_item = ContentItem.new(@content_store_response)

      expect(described_class.new(content_item).page_title).to_not include("[Withdrawn]")
      expect(described_class.new(content_item).page_title).to include(content_item.title)
    end
  end
end
