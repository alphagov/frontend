RSpec.describe ServiceManualTopicPresenter do
  describe "#when there should be an accordion" do
    let(:content_store_response) do
      response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => %w[def abc],
        },
        {
          "name" => "My group 2",
          "description" => "A summary of group 2",
          "content_ids" => [],
        },
        {
          "name" => "My group 3",
          "description" => "A summary of group 3",
          "content_ids" => [],
        },
      ]
      response["links"]["linked_items"] = [
        {
          "content_id" => "abc",
          "title" => "link title 1",
          "base_path" => "/link-href-abc",
        },
        {
          "content_id" => "def",
          "title" => "link title 2",
          "base_path" => "/link-href-def",
        },
      ]
      response["details"]["visually_collapsed"] = true
      response
    end

    let(:content_item) { ServiceManualTopic.new(content_store_response) }

    it "outputs accordion sections data" do
      expected = [
        {
          heading: {
            text: "My group 1",
          },
          summary: {
            text: "A summary of group 1",
          },
          content: {
            html: '<ul class="govuk-list"><li><a class="govuk-link" href="/link-href-def">link title 2</a></li><li><a class="govuk-link" href="/link-href-abc">link title 1</a></li></ul>',
          },
        },
      ]
      expect(described_class.new(content_item).accordion_sections).to eq(expected)
    end

    it "uses an accordion when there are more than two groups and visually_collapsed is true" do
      expect(described_class.new(content_item).display_as_accordion?).to be(true)
    end
  end

  describe "#when there should not be an accordion" do
    let(:content_store_response) do
      response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => %w[def abc],
        },
      ]
      response["links"]["linked_items"] = [
        {
          "content_id" => "abc",
          "title" => "link title 1",
          "base_path" => "/link-href-abc",
        },
        {
          "content_id" => "def",
          "title" => "link title 2",
          "base_path" => "/link-href-def",
        },
      ]
      response["details"]["visually_collapsed"] = false
      response
    end

    let(:content_item) { ServiceManualTopic.new(content_store_response) }

    it "does not use an accordion" do
      expect(described_class.new(content_item).display_as_accordion?).to be(false)
    end

    it "outputs sections data" do
      expected = [
        {
          heading: "My group 1",
          summary: "A summary of group 1",
          html: '<ul class="govuk-list"><li><a class="govuk-link" href="/link-href-def">link title 2</a></li><li><a class="govuk-link" href="/link-href-abc">link title 1</a></li></ul>',
        },
      ]
      expect(described_class.new(content_item).sections).to eq(expected)
    end
  end
end
