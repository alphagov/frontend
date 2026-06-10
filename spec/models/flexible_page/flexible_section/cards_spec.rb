RSpec.describe FlexiblePage::FlexibleSection::Cards do
  subject(:cards) { described_class.new(items:) }

  let(:items) do
    [
      {
        link: {
          text: "Writing implements",
          path: "/example",
        },
        description: "Pens, pencils, markers, crayons, chalk.",
      },
      {
        link: {
          text: "Bones present in the human foot",
          path: "/example",
        },
        description: "Talus, Calcaneus, Cuboid, Cuneiforms, Navicular, Metatarsals, Phalanges.",
      },
    ]
  end

  it "initialize sets the attributes from the parameters" do
    expect(cards.items).to eq(items)
  end
end
