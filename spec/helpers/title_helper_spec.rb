RSpec.describe TitleHelper do
  include described_class

  describe "#withdrawable_title" do
    it "returns a non-withdrawn title unchanged" do
      content_item = instance_double(FatalityNotice, title: "My Title", withdrawn?: false)

      expect(withdrawable_title(content_item)).to eq("My Title")
    end

    it "returns a withdrawn title prefixed with the text [Withdrawn]" do
      content_item = instance_double(FatalityNotice, title: "My Title", withdrawn?: true)

      expect(withdrawable_title(content_item)).to eq("[Withdrawn] My Title")
    end
  end
end
