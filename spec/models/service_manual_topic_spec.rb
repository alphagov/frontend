RSpec.describe ServiceManualTopic do
  describe "#groups" do
    subject(:service_manual_topic) { described_class.new(content_store_response) }

    let(:content_store_response) do
      GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
    end

    it "returns the expected responses" do
      expect(service_manual_topic.groups).to eq(content_store_response.dig("details", "groups"))
      expect(service_manual_topic.visually_collapsed?).to eq(content_store_response.dig("details", "visually_collapsed"))
    end

    it "returns content owners correctly" do
      expect(service_manual_topic.content_owners[0].title).to eq(content_store_response.dig("links", "content_owners")[0]["title"])
      expect(service_manual_topic.content_owners[0].base_path).to eq(content_store_response.dig("links", "content_owners")[0]["base_path"])

      expect(service_manual_topic.content_owners[1].title).to eq(content_store_response.dig("links", "content_owners")[1]["title"])
      expect(service_manual_topic.content_owners[1].base_path).to eq(content_store_response.dig("links", "content_owners")[1]["base_path"])
    end

    it "combines linked items into groups" do
      name = content_store_response.dig("details", "groups", 0, "name")
      description = content_store_response.dig("details", "groups", 0, "description")
      first_content_id = content_store_response.dig("details", "groups", 0, "content_ids", 0)

      expect(service_manual_topic.groups_with_links[0][:name]).to eq(name)
      expect(service_manual_topic.groups_with_links[0][:description]).to eq(description)
      expect(service_manual_topic.groups_with_links[0][:items][0].content_id).to eq(first_content_id)
    end
  end
end
