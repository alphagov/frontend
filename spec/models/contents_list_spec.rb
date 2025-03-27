RSpec.describe ContentsList do
  subject(:contents_list) do
    described_class.new({
      "items" => [
        { "href" => "#item-1", "text" => "Item 1" },
        { "href" => "#item-2", "text" => "Item 2" },
      ],
    })
  end

  describe "items attribute" do
    it "has the specified items as links" do
      expect(contents_list.items.count).to eq(2)
      expect(contents_list.items.first).to be_instance_of(Link)
      expect(contents_list.items.first.href).to eq("#item-1")
      expect(contents_list.items.first.text).to eq("Item 1")
      expect(contents_list.items.last.href).to eq("#item-2")
      expect(contents_list.items.last.text).to eq("Item 2")
    end
  end
end
