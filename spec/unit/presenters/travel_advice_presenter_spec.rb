RSpec.describe TravelAdvicePresenter do
  describe "#page_title" do
    it "includes the title of the current part when there are parts and the current part is not the first part" do
      content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "full-country")
      content_item = TravelAdvice.new(content_store_response)
      part_slug = content_store_response.dig("details", "parts").last["slug"]
      content_item.set_current_part(part_slug)

      expect(described_class.new(content_item).page_title).to include(content_item.current_part_title)
      expect(described_class.new(content_item).page_title).to include(content_item.title)
    end

    it "only uses the content item page title when when there are parts and the current part is the first part" do
      content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "full-country")
      content_item = TravelAdvice.new(content_store_response)
      part_slug = content_store_response.dig("details", "parts").first["slug"]
      content_item.set_current_part(part_slug)

      expect(described_class.new(content_item).page_title).to_not include(content_item.current_part_title)
      expect(described_class.new(content_item).page_title).to include(content_item.title)
    end

    it "only uses the content item page title when there aren't any parts" do
      content_store_response = GovukSchemas::Example.find("travel_advice", example_name: "no-parts")
      content_item = TravelAdvice.new(content_store_response)

      expect(described_class.new(content_item).page_title).to eq(content_item.title)
    end
  end
end
