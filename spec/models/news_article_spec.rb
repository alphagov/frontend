RSpec.describe NewsArticle do
  subject(:news_article) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("news_article", example_name: "best-practice-government-response") }

  it_behaves_like "it has updates", "news_article", "best-practice-event"
  it_behaves_like "it has no updates", "news_article", "news_article"
  it_behaves_like "it can have worldwide organisations", "news_article", "world_news_story_news_article"
  it_behaves_like "it can have emphasised organisations", "news_article", "world_news_story_news_article"
  it_behaves_like "it can have people", "news_article", "news_article"
  it_behaves_like "it has historical government information", "news_article", "news_article"
  it_behaves_like "it can be withdrawn", "news_article", "news_article_withdrawn"

  describe "#contributors" do
    it "returns the organisations ordered by emphasis" do
      organisations = content_store_response.dig("links", "organisations")

      expect(news_article.contributors.count).to eq(3)
      expect(news_article.contributors[0].title).to eq(organisations[0]["title"])
      expect(news_article.contributors[1].title).to eq(organisations[1]["title"])
      expect(news_article.contributors[2].title).to eq(organisations[2]["title"])
    end
  end
end
