RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "title" => "History Page",
      "details" => {
        "body" => "Hello",
        "headers" => [],
        "sidebar_image" => {
          "caption" => "Here's an image!",
          "url" => "https://assets.publishing.service.gov.uk/image.png",
        },
      },
    }
  end

  describe "flexible_sections attribute" do
    it "generates flexible sections if not supplied" do
      expect(history.flexible_sections.count).to eq(2)
      expect(history.flexible_sections.first).to be_instance_of(FlexiblePage::FlexibleSection::PageTitle)
      expect(history.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
    end

    context "when no sidebar image is provided" do
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
        expect(history.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
        expect(history.flexible_sections.second.image).to be_nil
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
