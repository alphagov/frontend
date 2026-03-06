# TODO: revisit the shared example in pub api and update it
RSpec.shared_examples "it has news article news image" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "presents the 'lead' type from details.images if present" do
    image = {
      "type" => "lead",
      "sources" =>
        {
          "s300" => "http://www.test.dev.gov.uk/image.jpg",
        },
    }
    content_item["details"]["images"] = [image]
    expect(described_class.new(content_item).image_url).to eq(image["sources"]["s300"])
  end

  it "falls back to details.image when details.images has no 'lead' type" do
    legacy_image = { "url" => "http://www.test.dev.gov.uk/legacy-image.jpg" }
    content_item["details"]["images"] = [
      {
        "type" => "other",
        "url" => "http://www.test.dev.gov.uk/other_image.jpg",
      },
    ]
    content_item["details"]["image"] = legacy_image

    expect(described_class.new(content_item).image_url).to eq(legacy_image["url"])
  end

  it "falls back to details.image when details.images is not provided" do
    content_item["details"]["images"] = nil
    legacy_image = { "url" => "http://www.test.dev.gov.uk/legacy-image.jpg" }
    content_item["details"]["image"] = legacy_image

    expect(described_class.new(content_item).image_url).to eq(legacy_image["url"])
  end

  it "presents a placeholder image if document has no image in the payload" do
    content_item["details"]["images"] = nil
    content_item["details"]["image"] = nil

    placeholder_image_url = "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg"
    expect(described_class.new(content_item).image_url).to eq(placeholder_image_url)
  end

  it "presents a placeholder image if world location news has no image in the payload" do
    content_item["details"]["images"] = nil
    content_item["details"]["image"] = nil
    content_item = {
      "document_type" => "world_news_story",
    }

    placeholder_image_url = "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg"
    expect(described_class.new(content_item).image_url).to eq(placeholder_image_url)
  end
end
