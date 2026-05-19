RSpec.describe FlexiblePage::FlexibleSection::RichContentsList do
  subject(:rich_contents_list) { described_class.new(contents_list:, image:) }

  let(:contents_list) do
    [
      { id: "introduction", text: "Introduction" },
      { id: "take_tour", text: "Take the tour" },
    ]
  end
  let(:image) { nil }

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(rich_contents_list.contents_list).to be_instance_of(ContentsOutline)
      expect(rich_contents_list.image).to be_nil
    end

    context "with an image attribute" do
      let(:image) do
        {
          alt: "Picture of No. 10",
          src: "https://example.gov.uk/no10.jpg",
        }
      end

      it "returns an image record" do
        expect(rich_contents_list.image.alt).to eq("Picture of No. 10")
        expect(rich_contents_list.image.src).to eq("https://example.gov.uk/no10.jpg")
      end
    end
  end
end
