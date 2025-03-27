RSpec.describe FlexiblePage::FlexibleSection::PageTitle do
  subject(:page_title) do
    described_class.new({
      "context" => "My Context",
      "heading_text" => "My Heading",
      "lead_paragraph" => "Welcome to this page",
    }, FlexiblePage.new({}))
  end

  describe "#initialize" do
    it "sets the attributes from the contents hash" do
      expect(page_title.context).to eq("My Context")
      expect(page_title.heading_text).to eq("My Heading")
      expect(page_title.lead_paragraph).to eq("Welcome to this page")
    end
  end
end
