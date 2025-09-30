RSpec.describe "Guide Print" do
  context "when visiting a guide at the print link" do
    let(:content_store_response) { GovukSchemas::Example.find("guide", example_name: "guide") }
    let(:base_path) { content_store_response.fetch("base_path") }

    before do
      stub_content_store_has_item(base_path, content_store_response)
      visit "#{base_path}/print"
    end

    it "renders the print view" do
      expect(page).to have_selector("#guide-print")
    end

    it "is not indexable by search engines" do
      expect(page).to have_selector("meta[name='robots'][content='noindex, nofollow']", visible: :hidden)
    end

    it "renders all parts in the print view" do
      parts = content_store_response["details"]["parts"]

      parts.each_with_index do |part, i|
        expect(page).to have_selector("h1", text: "#{i + 1}. #{part['title']}")
      end

      expect(page).to have_content("The ‘basic’ school curriculum includes the")
    end
  end
end
