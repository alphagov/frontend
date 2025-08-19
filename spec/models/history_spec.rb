RSpec.describe History do
  subject(:history) { described_class.new(content_store_response) }

  let(:content_store_response) do
    {
      "title" => "History Page",
      "details" => {
        "body" => "Hello",
        "headers" => [],
        "sidebar_image" => nil,
      },
    }
  end

  describe "flexible_sections attribute" do
    it "generates flexible sections if not supplied" do
      expect(history.flexible_sections.count).to eq(2)
      expect(history.flexible_sections.first).to be_instance_of(FlexiblePage::FlexibleSection::PageTitle)
      expect(history.flexible_sections.second).to be_instance_of(FlexiblePage::FlexibleSection::RichContent)
    end
  end
end
