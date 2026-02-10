RSpec.describe FlexiblePage::FlexibleSection::Breadcrumbs do
  subject(:flexible_section_hash) do
    {
      "breadcrumbs" => [
        {
          title: "History of the UK Government",
          url: "/government/history",
        },
      ],
    }
  end

  let(:breadcrumbs) { described_class.new(flexible_section_hash, FlexiblePage.new({})) }

  describe "#initialize" do
    it "sets the attributes from the flexible section hash" do
      expect(breadcrumbs.breadcrumbs).to eq(flexible_section_hash["breadcrumbs"])
    end
  end

  describe "#before_content?" do
    it "asks to be rendered in the before_content block" do
      expect(breadcrumbs.before_content?).to be true
    end
  end
end
