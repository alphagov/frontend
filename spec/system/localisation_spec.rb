RSpec.describe "Localisation" do
  let(:content_item) { GovukSchemas::Example.find(:news_article, example_name: "news_article") }
  let(:base_path) { content_item["base_path"] }

  before do
    # Ensure we request the Content Store version of the page
    stub_const(
      "ContentItemLoaders::GraphqlLoader::GRAPHQL_TRAFFIC_RATES",
      { "news_article" => 0 },
    )
    stub_content_store_has_item(base_path, content_item)
    visit base_path
  end

  describe "direction-rtl class" do
    it "does not have .direction-rtl on the .govuk-main-wrapper element" do
      expect(page).not_to have_selector(".govuk-main-wrapper.direction-rtl")
    end

    context "when viewing a page in an RTL language" do
      let(:content_item) { GovukSchemas::Example.find(:news_article, example_name: "news_article_news_story_translated_arabic") }

      it "has .direction-rtl on the .govuk-main-wrapper element" do
        expect(page).to have_selector(".govuk-main-wrapper.direction-rtl")
      end
    end
  end
end
