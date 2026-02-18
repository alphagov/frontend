RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "title" => "History Page",
      "details" => {
        "body" => "Hello",
        "headers" => [],
        "images" => images,
      },
    }
  end

  let(:images) do
    [
      {
        "type" => "sidebar",
        "caption" => "Here's an image!",
        "url" => "https://assets.publishing.service.gov.uk/image.png",
        "content_type" => "image/jpeg",
      },
    ]
  end

  describe "flexible_sections attribute" do
    it "generates flexible sections if not supplied" do
      expect(history.flexible_sections.count).to eq(3)
      expect(history.flexible_sections.first).to be_instance_of(FlexiblePage::FlexibleSection::Breadcrumbs)
      expect(history.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::PageTitle)
      expect(history.flexible_sections.third).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
    end

    context "when details.images has a 'sidebar' type image" do
      let(:expected_image_attributes) do
        {
          alt: "Here's an image!",
          src: "https://assets.publishing.service.gov.uk/image.png",
        }
      end

      it "includes the sidebar image in the rich content" do
        expect(history.flexible_sections.third.image).to have_attributes(expected_image_attributes)
      end
    end

    context "when details.images has no 'sidebar' type image" do
      let(:images) do
        [
          {
            "type" => "header",
            "caption" => "Ignore me",
            "url" => "https://assets.publishing.service.gov.uk/header-image.png",
            "content_type" => "image/jpeg",
          },
        ]
      end

      it "generates a rich content element without an image" do
        expect(history.flexible_sections.third).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
        expect(history.flexible_sections.third.image).to be_nil
      end
    end

    context "when no images are provided" do
      let(:images) { [] }

      it "generates a rich content element without an image" do
        expect(history.flexible_sections.third).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
        expect(history.flexible_sections.third.image).to be_nil
      end
    end

    context "when the images hash is missing" do
      let(:content_store_response) do
        {
          "title" => "History Page",
          "details" => {
            "body" => "Hello",
            "headers" => [],
          },
        }
      end

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
