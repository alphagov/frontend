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

  # test "it renders all parts in the print view" do
  #   setup_and_visit_guide_print("guide")
  #   parts = @content_item["details"]["parts"]

  #   parts.each_with_index do |part, i|
  #     assert page.has_css?("h1", text: "#{i + 1}. #{part['title']}")
  #   end

  #   assert page.has_content?("The ‘basic’ school curriculum includes the")
  # end

  # def setup_and_visit_guide_print(name)
  #   example = get_content_example_by_schema_and_name("guide", name)
  #   @content_item = example.tap do |item|
  #     stub_content_store_has_item(item["base_path"], item.to_json)
  #     visit "#{item['base_path']}/print"
  #   end
  # end
  end
end
