RSpec.describe "Fatality Notice" do
  let!(:content_item) { content_store_has_example_item("/government/news/christmas-2016-prime-ministers-message", schema: :news_article) }

  it_behaves_like "it has meta tags", "news_article", "news_article"

  context "when visiting a page" do
    before { visit "/government/news/christmas-2016-prime-ministers-message" }

    it "has a title" do
      expect(page).to have_title("#{content_item['title']} - GOV.UK")
    end

    it "has a heading" do
      expect(page).to have_css("h1", text: content_item["title"])
    end

    it "has a description" do
      expect(page).to have_text(content_item["description"])
    end

    it "has body text" do
      expect(page).to have_text("Her Majesty The Queen celebrated her 90th birthday")
    end

    it "has a link to translations of the message" do
      expect(page).to have_link("ردو", href: "/government/news/christmas-2016-prime-ministers-message.ur")
    end

    it "renders the lead image" do
      expect(page).to have_css("img[src*='s465_Christmas'][alt='Christmas']")
    end

    it "does not render with the single page notification button" do
      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end

  context "when visiting a page in history mode" do
    let!(:content_item) { content_store_has_example_item("/government/news/final-care-act-guidance-published", schema: :news_article, example: :news_article_history_mode) }

    before { visit "/government/news/final-care-act-guidance-published" }

    it "displays the history notice text" do
      expect(page).to have_text("This was published under the #{content_item['links']['government'][0]['title']}")
    end
  end

  context "when visiting an RTL page in history mode" do
    let!(:content_item) { content_store_has_example_item("/government/news/final-care-act-guidance-published.ar", schema: :news_article, example: :news_article_history_mode_translated_arabic) }

    before { visit "/government/news/final-care-act-guidance-published.ar" }

    it "marks up the government name correctly" do
      expect(page).to have_css("span[lang='en'][dir='ltr']", text: content_item["links"]["government"][0]["title"])
    end
  end
end
