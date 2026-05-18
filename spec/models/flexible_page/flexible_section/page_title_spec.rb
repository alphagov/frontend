RSpec.describe FlexiblePage::FlexibleSection::PageTitle do
  subject(:page_title) { described_class.new(context:, heading_text:, lead_paragraph:) }

  let(:context) { "My Context" }
  let(:heading_text) { "My Heading" }
  let(:lead_paragraph) { "Welcome to this page" }

  describe "#initialize" do
    it "sets the attributes from the parameters" do
      expect(page_title.context).to eq("My Context")
      expect(page_title.heading_text).to eq("My Heading")
      expect(page_title.lead_paragraph).to eq("Welcome to this page")
    end
  end
end
