RSpec.describe FlexiblePage::FlexibleSection::ContentThenSidebarLayout do
  subject(:content_then_sidebar_layout) { described_class.new(content:, sidebar:) }

  let(:content) { FlexiblePage::FlexibleSection::Base.new({}) }
  let(:sidebar) { FlexiblePage::FlexibleSection::Base.new({}) }

  describe "#initialize" do
    it "sets the attributes" do
      expect(content_then_sidebar_layout.content).to eq(content)
      expect(content_then_sidebar_layout.sidebar).to eq(sidebar)
    end
  end
end
