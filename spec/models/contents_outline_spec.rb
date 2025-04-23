RSpec.describe ContentsOutline do
  subject(:contents_outline) do
    described_class.new([
      {
        "id" => "item-1",
        "text" => "Item 1",
        "level" => 2,
        "headers" => [
          {
            "id" => "nested-item-1",
            "text" => "Nested Item 1",
            "level" => 3,
          },
        ],
      },
      {
        "id" => "item-2",
        "text" => "Item 2",
        "level" => 2,
      },
    ])
  end

  describe "items attribute" do
    it "has the specified items" do
      expect(contents_outline.items.count).to eq(2)
      expect(contents_outline.items.first).to be_instance_of(ContentsOutline::Item)
      expect(contents_outline.items.first.id).to eq("item-1")
      expect(contents_outline.items.first.text).to eq("Item 1")

      expect(contents_outline.items.last.id).to eq("item-2")
      expect(contents_outline.items.last.text).to eq("Item 2")
      expect(contents_outline.items.last.items).to eq([])
    end

    it "has nested items" do
      nested_items = contents_outline.items.first.items

      expect(nested_items.count).to eq(1)
      expect(nested_items.first.id).to eq("nested-item-1")
      expect(nested_items.first.text).to eq("Nested Item 1")
      expect(nested_items.first.items).to eq([])
    end
  end

  describe "#level_two_headers?" do
    context "and level two headers exist" do
      it "returns true" do
        expect(contents_outline.level_two_headers?).to be(true)
      end
    end

    context "and level two headers exist in a nested struture" do
      subject(:contents_outline) do
        described_class.new([
          {
            "id" => "item-1",
            "text" => "Item 1",
            "level" => 1,
            "headers" => [
              {
                "id" => "nested-item-1",
                "text" => "Nested Item 1",
                "level" => 2,
              },
            ],
          },
        ])
      end

      it "returns true" do
        expect(contents_outline.level_two_headers?).to be(true)
      end
    end

    context "and level two headers do not exist" do
      subject(:contents_outline) do
        described_class.new([
          {
            "id" => "item-1",
            "text" => "Item 1",
            "level" => 1,
          },
        ])
      end

      it "returns false" do
        expect(contents_outline.level_two_headers?).to be(false)
      end
    end
  end
end
