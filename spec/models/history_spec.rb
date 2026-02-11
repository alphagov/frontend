RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "title" => "History Page",
      "details" => details,
    }
  end

  let(:base_details) do
    {
      "body" => "Hello",
      "headers" => [],
    }
  end

  let(:sidebar_image) do
    {
      "caption" => "Here's an image!",
      "url" => "https://assets.publishing.service.gov.uk/image.png",
    }
  end

  let(:details) do
    base_details.merge(
      "sidebar_image" => sidebar_image,
    )
  end

  let(:expected_image_attributes) do
    {
      alt: "Here's an image!",
      src: "https://assets.publishing.service.gov.uk/image.png",
    }
  end

  describe "flexible_sections attribute" do
    it "generates flexible sections if not supplied" do
      expect(history.flexible_sections.count).to eq(3)
      expect(history.flexible_sections.first).to be_instance_of(FlexiblePage::FlexibleSection::Breadcrumbs)
      expect(history.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::PageTitle)
      expect(history.flexible_sections.third).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
    end

    context "when details.images has a 'sidebar' type image" do
      let(:details) do
        base_details.merge(
          "images" => [
            sidebar_image.merge("type" => "sidebar"),
          ],
        )
      end

      it "uses the 'sidebar' type image from details.images" do
        expect(history.flexible_sections.third.image).to have_attributes(expected_image_attributes)
      end
    end

    context "when details.images has no 'sidebar' type image" do
      let(:details) do
        base_details.merge(
          "images" => [
            {
              "type" => "header",
              "caption" => "Ignore me",
              "url" => "https://assets.publishing.service.gov.uk/header-image.png",
            },
          ],
          "sidebar_image" => sidebar_image,
        )
      end

      it "falls back to details.sidebar_image" do
        expect(history.flexible_sections.third.image).to have_attributes(expected_image_attributes)
      end
    end

    context "when details.images is empty" do
      let(:details) do
        base_details.merge(
          "sidebar_image" => sidebar_image,
        )
      end

      it "falls back to details.sidebar_image" do
        expect(history.flexible_sections.third.image).to have_attributes(expected_image_attributes)
      end
    end

    context "when both details.images and details.sidebar_image are provided" do
      let(:details) do
        base_details.merge(
          "images" => [
            {
              "type" => "sidebar",
              "caption" => "Image from details.images",
              "url" => "https://assets.publishing.service.gov.uk/images-image.png",
            },
          ],
          "sidebar_image" => {
            "caption" => "Image from details.sidebar_image",
            "url" => "https://assets.publishing.service.gov.uk/sidebar-image.png",
          },
        )
      end

      it "prefers details.images over details.sidebar_image" do
        expect(history.flexible_sections.third.image).to have_attributes(
          alt: "Image from details.images",
          src: "https://assets.publishing.service.gov.uk/images-image.png",
        )
      end
    end

    context "when no sidebar image is provided" do
      let(:details) { base_details }

      it "generates a rich content element without an image" do
        expect(history.flexible_sections.third).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
        expect(history.flexible_sections.third.image).to be_nil
      end
    end
  end

  describe "#breadcrumbs" do
    it "extends the base breadcrumbs to add /government/history" do
      expect(history.breadcrumbs.count).to eq(2)
      expect(history.breadcrumbs.last).to eq(
        {
          title: "History of the UK Government",
          url: "/government/history",
        },
      )
    end
  end
end
