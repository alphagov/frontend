RSpec.describe NewsArticle do
  subject(:news_article) { described_class.new(content_store_response) }

  let(:content_store_response) { GovukSchemas::Example.find("news_article", example_name: "world_news_story_news_article") }

  it_behaves_like "it has updates", "news_article", "news_article"
  it_behaves_like "it has no updates", "news_article", "news_article"
  it_behaves_like "it can have worldwide organisations", "news_article", "world_news_story_news_article"
  it_behaves_like "it can have emphasised organisations", "news_article", "world_news_story_news_article"
  it_behaves_like "it can have people", "news_article", "news_article"
  it_behaves_like "it has historical government information", "news_article", "news_article"
  it_behaves_like "it can be withdrawn", "news_article", "news_article_withdrawn"
end
