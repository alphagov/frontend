RSpec.describe ServiceManualTopicPresenter do
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
    response
  end

  let(:content_item) { ServiceManualTopic.new(content_store_response) }

  describe "#sections" do
    it "outputs data for the accordion component" do
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
      expect(described_class.new(content_item).sections).to eq(expected)
    end
  end
end
