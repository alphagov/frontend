RSpec.describe NewsArticle do
  subject(:news_article) { described_class.new(content_item) }

  it_behaves_like "it has news image", "news_article", "news_article"
  it_behaves_like "it has updates", "news_article", "best-practice-event"
  it_behaves_like "it has no updates", "news_article", "news_article"
  it_behaves_like "it can have worldwide organisations", "news_article", "world_news_story_news_article"
  it_behaves_like "it can have emphasised organisations", "news_article", "news_article"
  it_behaves_like "it can have people", "news_article", "news_article"
  it_behaves_like "it has historical government information", "news_article", "news_article"
  it_behaves_like "it can be withdrawn", "news_article", "news_article_withdrawn"

  describe "#contributors" do
    let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "best-practice-government-response") }

    it "returns the organisations ordered by emphasis" do
      organisations = content_item.dig("links", "organisations")

      expect(news_article.contributors.count).to eq(3)
      expect(news_article.contributors[0].title).to eq(organisations[0]["title"])
      expect(news_article.contributors[1].title).to eq(organisations[1]["title"])
      expect(news_article.contributors[2].title).to eq(organisations[2]["title"])
    end
  end

  describe "#image" do
    describe "document is a news article with a custom lead image" do
      let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "news_article") }

      it "fetches lead image from the details" do
        expect(news_article.image).to eq(content_item.dig("details", "image"))
      end
    end

    describe "document is a news article without a custom lead image" do
      let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "best-practice-news-story") }

      it "fetches lead image from primary publishing organisation" do
        content_item["details"] = content_item["details"].delete("image") # drop the custom image so we can test the fallback
        content_item["links"]["primary_publishing_organisation"] = [
          "details" => {
            "default_news_image" => {
              "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
              "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
            },
          },
        ]
        expect(news_article.image).to eq(content_item.dig("links", "primary_publishing_organisation")[0].dig("details", "default_news_image"))
      end
    end

    describe "document is a news article without a custom lead image, nor default news image on the primary organisation" do
      let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "best-practice-news-story") }

      it "fetches lead image from the first organisation" do
        content_item["details"] = content_item["details"].delete("image") # drop the custom image so we can test the fallback
        content_item["links"]["primary_publishing_organisation"][0]["default_news_image"] = nil # drop the default news image so we can test the fallback
        content_item["links"]["organisations"] = [
          { "details" =>
            {
              "default_news_image" => {
                "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
                "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
              },
            } },
        ]
        expect(news_article.image).to eq(content_item.dig("links", "organisations")[0].dig("details", "default_news_image"))
      end

      it "falls back to placeholder image" do
        content_item["details"] = content_item["details"].delete("image") # drop the custom image so we can test the fallback
        content_item["links"]["primary_publishing_organisation"][0]["details"]["default_news_image"] = nil # drop the default news image so we can test the fallback
        content_item["links"]["organisations"][0]["details"]["default_news_image"] = nil # drop the default news image so we can test the fallback

        expect(news_article.image).to include({ "url" => "https://assets.publishing.service.gov.uk/media/5e59279b86650c53b2cefbfe/placeholder.jpg" })
      end
    end

    describe "document is a world news story without a custom lead image" do
      let(:content_item) { GovukSchemas::Example.find("news_article", example_name: "world_news_story_news_article") }

      it "fetches lead image from worldwide organisation" do
        content_item["details"] = content_item["details"].delete("image") # drop the custom image so we can test the fallback
        content_item["links"]["worldwide_organisations"] = [
          { "details" => {
            "default_news_image" => {
              "high_resolution_url" => "https://assets.publishing.service.gov.uk/media/621e4de4e90e0710be0354d7/s960_fcdo-main-building.jpg",
              "url" => "https://assets.publishing.service.gov.uk/media/621e4de48fa8f5490aff83b4/s300_fcdo-main-building.jpg",
            },
          } },
        ]
        expect(news_article.image).to eq(content_item.dig("links", "worldwide_organisations")[0].dig("details", "default_news_image"))
      end
    end
  end
end
