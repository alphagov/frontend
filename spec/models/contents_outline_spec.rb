RSpec.describe ContentsOutline do
  subject(:contents_outline) do
    described_class.new([
      {
        "id" => "item-1",
        "text" => "Item 1",
        "level" => 2,
        "headers" => [{ "id" => "sub-item-1", "text" => "Sub-Item 1", "level" => 3 }],
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
      expect(contents_outline.items.first.items.count).to eq(1)
      expect(contents_outline.items.first.items.first.id).to eq("sub-item-1")
      expect(contents_outline.items.last.id).to eq("item-2")
      expect(contents_outline.items.last.text).to eq("Item 2")
    end
  end
end
