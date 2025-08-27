RSpec.describe FlexiblePage::FlexibleSection::RichContent do
  subject(:content_hash) do
    {
      "contents_list" => [
        { "id" => "introduction", "text" => "Introduction" },
        { "id" => "take_tour", "text" => "Take the tour" },
      ],
      "govspeak" => "<h2>Hello!</h2>",
      "image" => {
        "alt" => "Picture of No. 10",
        "src" => "https://example.gov.uk/no10.jpg",
      },
    }
  end

  let(:rich_content) { described_class.new(content_hash, FlexiblePage.new({})) }

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(rich_content.contents_list).to be_instance_of(ContentsOutline)
      expect(rich_content.govspeak).to eq("<h2>Hello!</h2>")
    end
  end

  describe "image attribute" do
    it "returns an image record" do
      expect(rich_content.image.alt).to eq("Picture of No. 10")
      expect(rich_content.image.src).to eq("https://example.gov.uk/no10.jpg")
    end

    context "with no image supplied" do
      let(:content_hash) do
        {
          "contents_list" => [
            { "id" => "introduction", "text" => "Introduction" },
            { "id" => "take_tour", "text" => "Take the tour" },
          ],
          "govspeak" => "<h2>Hello!</h2>",
        }
      end

      it "returns nil" do
        expect(rich_content.image).to be_nil
      end
    end
  end
end
