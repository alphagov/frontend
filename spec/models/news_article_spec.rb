RSpec.describe NewsArticle do
  %i[content_store publishing_api_graphql].each do |data_source|
    context "when data source is #{data_source}" do
      it_behaves_like "it has updates", "news_article", "best-practice-event", data_source: data_source
      it_behaves_like "it has no updates", "news_article", "news_article", data_source: data_source
      it_behaves_like "it can have worldwide organisations", "news_article", "world_news_story_news_article", data_source: data_source
      it_behaves_like "it can have emphasised organisations", "news_article", "news_article", data_source: data_source
      it_behaves_like "it can have people", "news_article", "news_article", data_source: data_source
      it_behaves_like "it has historical government information", "news_article", "news_article", data_source: data_source
      it_behaves_like "it can be withdrawn", "news_article", "news_article_withdrawn", data_source: data_source
    end

    describe "#contributors" do
      subject(:news_article) { described_class.new(api_response) }

      let(:api_response) { fetch_content_item("news_article", "best-practice-government-response", data_source: data_source) }

      it "returns the organisations ordered by emphasis" do
        organisations = api_response.dig("links", "organisations")

        expect(news_article.contributors.count).to eq(3)
        expect(news_article.contributors[0].title).to eq(organisations[0]["title"])
        expect(news_article.contributors[1].title).to eq(organisations[1]["title"])
        expect(news_article.contributors[2].title).to eq(organisations[2]["title"])
      end
    end
  end
end
