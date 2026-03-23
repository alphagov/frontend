RSpec.shared_examples "it has lead image" do |document_type, example_name|
  let(:content_item) { GovukSchemas::Example.find(document_type, example_name:) }

  it "presents the 'lead' type image from details.images if present" do
    image = {
      "type" => "lead",
      "caption" => "An image caption",
      "content_type" => "image/jpeg",
      "sources" =>
        {
          "s960" => "http://www.test.dev.gov.uk/s960_image.jpg",
          "s712" => "http://www.test.dev.gov.uk/s712_image.jpg",
          "s630" => "http://www.test.dev.gov.uk/s630_image.jpg",
          "s465" => "http://www.test.dev.gov.uk/s465_image.jpg",
          "s300" => "http://www.test.dev.gov.uk/s300_image.jpg",
          "s216" => "http://www.test.dev.gov.uk/s216_image.jpg",
        },
    }
    content_item["details"]["images"] = [image]

    expect(described_class.new(content_item).image).to eq(image)
    expect(described_class.new(content_item).image_url).to eq(image.dig("sources", "s300"))
  end

  it "#image_url falls back to details.image when details.images has no 'lead' type" do
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

  it "#image_url falls back to details.image when details.images is not provided" do
    content_item["details"]["images"] = nil
    legacy_image = { "url" => "http://www.test.dev.gov.uk/legacy-image.jpg" }
    content_item["details"]["image"] = legacy_image

    expect(described_class.new(content_item).image_url).to eq(legacy_image["url"])
  end

  it "#image_url returns nil if details.images has no 'lead' type, and there is no details.image fallback" do
    content_item["details"]["images"] = [
      {
        "type" => "other",
        "url" => "http://www.test.dev.gov.uk/other_image.jpg",
      },
    ]
    content_item["details"]["image"] = nil

    expect(described_class.new(content_item).image_url).to be_nil
  end

  it "#image_url returns nil if the document has no image in the payload" do
    content_item["details"]["images"] = nil
    content_item["details"]["image"] = nil

    expect(described_class.new(content_item).image).to be_nil
    expect(described_class.new(content_item).image_url).to be_nil
  end
end
