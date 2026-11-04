RSpec.describe "News Article" do
  let(:base_path) { "/government/news/christmas-2016-prime-ministers-message" }
  let!(:content_item) { content_store_has_example_item(base_path, schema: :news_article) }

  before { visit base_path }

  describe "rendering meta tags" do
    it_behaves_like "it has meta tags", "news_article", "news_article"
  end

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
    expect(page).to have_css("img[src*='s300_Christmas'][alt='Christmas']")
  end

  it "does not render with the single page notification button" do
    expect(page).not_to have_css(".gem-c-single-page-notification-button")
  end

  context "when the page has history" do
    let(:base_path) { "/government/news/cde-innovation-network-event-9-july-2015-london" }
    let!(:content_item) { content_store_has_example_item(base_path, schema: :news_article, example: "best-practice-event") }

    it "displays the metadata at the top of the page" do
      within all(".gem-c-metadata")[0] do
        expect(page).to have_content("From: Centre for Defence Enterprise and Defence Science and Technology Laboratory")
        expect(page).to have_content("Published: 25 March 2015")
        expect(page).to have_content("Last updated: 13 July 2015")
      end
    end

    it "displays the page history at the bottom of the page" do
      within all(".gem-c-metadata")[1] do
        expect(page).to have_content("Last updated: 13 July 2015")
        expect(page).to have_content("30 April 2015")
        expect(page).to have_content("Change of venue")
      end
    end
  end

  context "when content item has an image caption" do
    let(:base_path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations" }
    let(:content_item) { content_store_has_example_item(base_path, schema: :news_article, example: :news_article_with_image_caption) }

    it "renders a caption for the lead image" do
      expect(page).to have_css("figcaption p", text: "British High Commissioner, Jane Marriott CMG OBE with Chief Guest, Ahsan Iqbal at the Islamabad KBP.")
    end
  end

  context "when content item has a high resolution image" do
    let(:base_path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations" }
    let(:content_item) { content_store_has_example_item(base_path, schema: :news_article, example: :news_article_with_image_caption) }

    it "includes the high resolution image in the meta tags" do
      expect(page).to have_css("meta[property='og:image'][content*='s960']", visible: :hidden)
      expect(page).to have_css("meta[name='twitter:image'][content*='s960']", visible: :hidden)
    end
  end
end
