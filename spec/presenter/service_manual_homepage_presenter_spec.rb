RSpec.describe ServiceManualHomepagePresenter do
  let(:content_store_response) do
    response = GovukSchemas::Example.find("service_manual_homepage", example_name: "service_manual_homepage")
    response["links"]["children"][0]["title"] = "Zed zed zed zed"
    response["links"]["children"][3]["title"] = "Aardvark"

    response["links"]["children"][3]["base_path"] = "/service_manual"
    response["links"]["children"][3]["description"] = "This is a description y'all"
    response
  end

  let(:content_item) { ServiceManualHomepage.new(content_store_response) }

  describe "#sorted_topics" do
    it "sorts the topics alphabetically" do
      expect(described_class.new(content_item).sorted_topics.first[:link][:text]).to eq("Aardvark")
      expect(described_class.new(content_item).sorted_topics.last[:link][:text]).to eq("Zed zed zed zed")
    end

    it "returns the expected data" do
      expected = {
        link: {
          path: "/service_manual",
          text: "Aardvark",
        },
        description: "This is a description y'all",
      }
      expect(described_class.new(content_item).sorted_topics.first).to eq(expected)
    end
  end
end
