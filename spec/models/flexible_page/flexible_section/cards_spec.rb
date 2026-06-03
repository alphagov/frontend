RSpec.describe FlexiblePage::FlexibleSection::Cards do
  subject(:cards) { described_class.new(items:, heading_level:) }

  let(:heading_level) { nil }
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

    it "sets the heading level correctly" do
      expect(cards.heading).to eq("h2")
    end
  end

  describe "with a custom heading level" do
    let(:heading_level) { 3 }

    it "sets the heading level correctly" do
      expect(cards.heading).to eq("h3")
    end
  end

  describe "with an invalid heading level" do
    let(:heading_level) { 3000 }

    it "sets the heading level correctly" do
      expect(cards.heading).to eq("h2")
    end
  end
end
