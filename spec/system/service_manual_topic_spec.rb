RSpec.describe "Service manual topic page" do
  describe "GET /<document_type>" do
    let(:content_store_response) { GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path
    end

    it "uses topic description as meta description" do
      description = page.find("meta[name=\"description\"]", visible: :hidden)["content"]
      expect(description).to eq(content_store_response["description"])
    end

    it "shows the 'Join the community' title" do
      expect(page).to have_css("h2", text: "Join the community")
    end

    it "shows the right community in the 'Join' title if there is only one" do
      content_store_response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      content_store_response["links"]["content_owners"] = [
        {
          "base_path": "/service-manual/communities/agile-delivery-community",
          "title": "Agile delivery community",
        },
      ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).to have_css("h2", text: "Join the Agile delivery community")
    end

    it "lists communities in the sidebar" do
      links = content_store_response["links"]["content_owners"]

      expect(page).to have_link(links[0]["title"], href: links[0]["base_path"])
      expect(page).to have_link(links[1]["title"], href: links[1]["base_path"])
    end

    it "doesn't display content in an accordion if only one group and visually collapsed is false" do
      content_store_response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      content_store_response["details"]["visually_collapsed"] = false
      content_store_response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => %w[def abc],
        },
      ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).not_to have_css(".gem-c-accordion")
    end

    it "doesn't display content in an accordion if only one group and visually collapsed is true" do
      content_store_response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      content_store_response["details"]["visually_collapsed"] = true
      content_store_response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => %w[def abc],
        },
      ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).not_to have_css(".gem-c-accordion")
    end

    it "displays content using an accordion if more than two groups and visually collapsed is true" do
      content_store_response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      valid_content_id = content_store_response["links"]["linked_items"][0]["content_id"]
      content_store_response["details"]["visually_collapsed"] = true
      content_store_response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => [valid_content_id],
        },
        {
          "name" => "My group 2",
          "description" => "A summary of group 2",
          "content_ids" => [valid_content_id],
        },
        {
          "name" => "My group 3",
          "description" => "A summary of group 3",
          "content_ids" => [valid_content_id],
        },
      ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).to have_css(".gem-c-accordion")
    end

    it "doesn't display content using an accordion if more than two groups and visually collapsed is false" do
      content_store_response = GovukSchemas::Example.find("service_manual_topic", example_name: "service_manual_topic")
      valid_content_id = content_store_response["links"]["linked_items"][0]["content_id"]
      content_store_response["details"]["visually_collapsed"] = false
      content_store_response["details"]["groups"] = [
        {
          "name" => "My group 1",
          "description" => "A summary of group 1",
          "content_ids" => [valid_content_id],
        },
        {
          "name" => "My group 2",
          "description" => "A summary of group 2",
          "content_ids" => [valid_content_id],
        },
        {
          "name" => "My group 3",
          "description" => "A summary of group 3",
          "content_ids" => [valid_content_id],
        },
      ]
      stub_content_store_has_item(base_path, content_store_response)
      visit base_path

      expect(page).not_to have_css(".gem-c-accordion")
    end

    it "includes a link to subscribe for email alerts" do
      expect(page).to have_link("Get emails when any guidance within this topic is updated", href: "/email-signup?link=#{content_store_response['base_path']}")
    end
  end
end
