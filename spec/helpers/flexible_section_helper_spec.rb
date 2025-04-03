RSpec.describe FlexibleSectionHelper do
  include described_class

  describe "#render_flexible_section" do
    it "contains error items" do
      flexible_section = double(FlexiblePage::FlexibleSection::Base, type: "fake")
      expect(self).to receive(:render).with("flexible_page/flexible_sections/fake", flexible_section:)

      render_flexible_section(flexible_section)
    end
  end
end