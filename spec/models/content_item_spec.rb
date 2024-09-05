RSpec.describe ContentItem do
  describe "#initialize" do
    it "leaves ordered_related_items if set" do
      subject = described_class.new(
        {
          "links" => {
            "ordered_related_items" => [1, 2],
            "suggested_ordered_related_items" => [3, 4],
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([1, 2])
    end

    it "uses suggested_ordered_related_items if no ordered_related_items" do
      subject = described_class.new(
        {
          "links" => {
            "suggested_ordered_related_items" => [3, 4],
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([3, 4])
    end

    it "returns an empty set if neither key is set" do
      subject = described_class.new(
        {
          "links" => {},
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([])
    end

    it "returns an empty set if ordered_related_items_overrides is present" do
      subject = described_class.new(
        {
          "links" => {
            "ordered_related_items" => [1, 2],
            "ordered_related_items_overrides" => "true",
          },
        },
      )

      expect(subject.to_h["links"]["ordered_related_items"]).to eq([])
    end
  end

  describe "#available_translations" do
    it "returns sorted translations with default translation at the top" do
      subject = described_class.new(
        {
          "links" => {
            "available_translations" => [
              { "locale" => "cy" },
              { "locale" => "en" },
            ],
          },
        },
      )

      expect(subject.available_translations).to eq([
        { "locale" => "en" },
        { "locale" => "cy" },
      ])
    end
  end
end
