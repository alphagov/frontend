RSpec.describe FlexiblePage::FlexibleSection::SidebarThenContentLayout do
  subject(:sidebar_then_content_layout) { described_class.new(content:, sidebar:) }

  let(:content) { FlexiblePage::FlexibleSection::Base.new({}) }
  let(:sidebar) { FlexiblePage::FlexibleSection::Base.new({}) }

  describe "#initialize" do
    it "sets the attributes" do
      expect(sidebar_then_content_layout.content).to eq(content)
      expect(sidebar_then_content_layout.sidebar).to eq(sidebar)
    end
  end
end
