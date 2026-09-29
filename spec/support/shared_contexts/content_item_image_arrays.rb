# You can include this in a spec test if the test has let blocks
# that provide `schema_name` and `example_name`, and which uses
# `content_store_response` to build models.
module SharedContexts
  module ContentItemImageArrays
    shared_context "with no details/images" do
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["details"].delete("images")
        end
      end
    end

    shared_context "when details/images has a single image of type " do |image_type|
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["details"]["images"] = [dummy_image(image_type)]
        end
      end
    end

    shared_context "when details/images has multiple images of types " do |image_type_array|
      let(:content_store_response) do
        GovukSchemas::Example.find(schema_name, example_name:).tap do |item|
          item["details"]["images"] = image_type_array.map { dummy_image(it) }
        end
      end
    end

    def dummy_image(type)
      {
        "caption": "Custom caption and credit",
        "content_type": "image/png",
        "sources": {
          "desktop" => "https://example.com/desktop.png",
          "desktop_2x" => "https://example.com/desktop_2x.png",
          "mobile" => "https://example.com/mobile.png",
          "mobile_2x" => "https://example.com/mobile_2x.png",
          "tablet" => "https://example.com/tablet.png",
          "tablet_2x" => "https://example.com/tablet_2x.png",
        },
        "type" => type,
      }
    end
  end
end
