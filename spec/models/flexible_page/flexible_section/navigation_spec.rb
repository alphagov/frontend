RSpec.describe FlexiblePage::FlexibleSection::Navigation do
  subject(:navigation) { described_class.new(items:) }

  let(:items) do
    {
      title: "Test heading",
      href: "/test-heading",
    }
  end

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(navigation.items).to eq(
        { title: "Test heading",
          href: "/test-heading" },
      )
    end
  end
end
