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
  end

  test "renders the lead image" do
    setup_and_visit_content_item("news_article")
    assert page.has_css?("img[src*='s465_Christmas'][alt='Christmas']")
  end

  test "renders history notice" do
    setup_and_visit_content_item("news_article_history_mode")

    within ".govuk-notification-banner__content" do
      assert page.has_text?("This was published under the 2010 to 2015 Conservative and Liberal Democrat coalition government")
    end
  end

  test "marks up government name correctly" do
    setup_and_visit_content_item("news_article_history_mode_translated_arabic")

    within ".govuk-notification-banner__content" do
      assert page.has_css?("span[lang='en'][dir='ltr']", text: "2022 to 2024 Sunak Conservative government")
    end
  end

  test "does not render with the single page notification button" do
    setup_and_visit_content_item("news_article")
    assert_not page.has_css?(".gem-c-single-page-notification-button")
  end
end
