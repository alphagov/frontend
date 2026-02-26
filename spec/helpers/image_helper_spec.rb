RSpec.describe ImageHelper do
  include described_class

  describe "#srcset_string" do
    let(:image) { { sources: { desktop: "my.png", desktop_2x: "my2x.png" } } }

    it "creates a valid srcset string" do
      expect(srcset_string(:desktop, image)).to eq("/images/my.png, /images/my2x.png 2x")
    end

    context "when no 2x images are available" do
      let(:image) { { sources: { desktop: "my.png" } } }

      it "creates a valid srcset string with only one image" do
        expect(srcset_string(:desktop, image)).to eq("/images/my.png")
      end
    end
  end
end
