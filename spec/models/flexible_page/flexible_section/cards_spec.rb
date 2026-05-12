RSpec.describe FlexiblePage::FlexibleSection::Cards do
  subject(:cards) { described_class.new(items:) }

  let(:items) do
    [
      {
        title: "Writing implements",
        href: "/example",
        description: "Pens, pencils, markers, crayons, chalk.",
      },
      {
        title: "Bones present in the human foot",
        href: "/example",
        description: "Talus, Calcaneus, Cuboid, Cuneiforms, Navicular, Metatarsals, Phalanges.",
      },
    ]
  end

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(cards.items).to eq(items)
    end
  end
end
