RSpec.shared_examples "it has news image" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  before do
    content_item["details"]["image"] = nil
  end

  it "presents the document's image if present" do
    image = { "url" => "http://www.test.dev.gov.uk/lead_image.jpg" }
    content_item["details"]["image"] = image

    expect(described_class.new(content_item).image).to eq(image)
  end

  it "presents the document's organisation's default_news_image if document's image is not present" do
    default_news_image = { "url" => "http://www.test.dev.gov.uk/default_news_image.jpg" }
    content_item = {
      "links" => {
        "primary_publishing_organisation" => [
          { "details" => { "default_news_image" => default_news_image } },
        ],
      },
    }

    expect(described_class.new(content_item).image).to eq(default_news_image)
  end

  it "presents a placeholder image if document has no image or default news image" do
    placeholder_image = { "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" }
    content_item = {
      "links" => {
        "primary_publishing_organisation" => [],
      },
    }
    expect(described_class.new(content_item).image).to eq(placeholder_image)
  end

  it "presents a placeholder image if world location news has no image or default news image" do
    content_item = {
      "document_type" => "world_news_story",
    }
    placeholder_image = { "url" => "https://assets.publishing.service.gov.uk/media/5e985599d3bf7f3fc943bbd8/UK_government_logo.jpg" }

    expect(described_class.new(content_item).image).to eq(placeholder_image)
  end
end
