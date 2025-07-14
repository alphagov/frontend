RSpec.describe ServiceManualTopicPresenter do
  response_links = [
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

  describe "#service_manual_topics" do
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
      response["links"]["linked_items"] = response_links
      response["details"]["visually_collapsed"] = true
      response["links"]["content_owners"] = [
        {
          "title" => "First community",
          "base_path" => "/first/base/path",
        },
      ]
      response["base_path"] = "/thisismybasepath/"
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

    it "outputs sections data" do
      expected = [
        {
          heading: "My group 1",
          summary: "A summary of group 1",
          list: [
            '<a class="govuk-link" href="/link-href-def">link title 2</a>',
            '<a class="govuk-link" href="/link-href-abc">link title 1</a>',
          ],
        },
      ]
      expect(described_class.new(content_item).sections).to eq(expected)
    end

    it "uses an accordion when there are more than two groups and visually_collapsed is true" do
      expect(described_class.new(content_item).display_as_accordion?).to be(true)
    end

    it "correctly formats content owners" do
      expected = [
        {
          href: "/first/base/path",
          title: "First community",
        },
      ]
      expect(described_class.new(content_item).content_owners).to eq(expected)
    end

    it "sets a specific community title when there is only one" do
      expect(described_class.new(content_item).community_title).to eq("Join the First community")
    end

    it "creates the correct email signup link" do
      expect(described_class.new(content_item).email_alert_signup_link).to eq("/email-signup?link=/thisismybasepath/")
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
      response["links"]["linked_items"] = response_links
      response["details"]["visually_collapsed"] = false
      response["links"]["content_owners"] = [
        {
          "title" => "First community",
          "base_path" => "/first/base/path",
        },
        {
          "title" => "Second community",
          "base_path" => "/second/base/path",
        },
      ]
      response
    end

    let(:content_item) { ServiceManualTopic.new(content_store_response) }

    it "does not use an accordion" do
      expect(described_class.new(content_item).display_as_accordion?).to be(false)
    end

    it "sets a generic community title when there is more than one" do
      expect(described_class.new(content_item).community_title).to eq("Join the community")
    end

    it "creates community links correctly" do
      expected = ["<a class=\"govuk-link\" href=\"/first/base/path\">First community</a>", "<a class=\"govuk-link\" href=\"/second/base/path\">Second community</a>"]
      expect(described_class.new(content_item).community_links).to eq(expected)
    end
  end
end
