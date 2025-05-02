RSpec.describe "News Article" do
  let!(:content_item) { content_store_has_example_item("/government/news/christmas-2016-prime-ministers-message", schema: :news_article) }

  %i[content_store publishing_api_graphql].each do |data_source|
    context "when data source is #{data_source}" do
      it_behaves_like "it has meta tags", "news_article", "news_article", data_source: data_source
    end
  end

  shared_examples "a news article page" do
    before { visit path }

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

  shared_examples "a news article page with an image caption" do
    before { visit path }

    it "renders a caption for the lead image" do
      expect(page).to have_css("figcaption p", text: "British High Commissioner, Jane Marriott CMG OBE with Chief Guest, Ahsan Iqbal at the Islamabad KBP.")
    end
  end

  shared_examples "a news article page with a high resolution image" do
    before { visit path }

    it "includes the high resolution image in the meta tags" do
      expect(page).to have_css("meta[property='og:image'][content*='s960']", visible: :hidden)
      expect(page).to have_css("meta[name='twitter:image'][content*='s960']", visible: :hidden)
    end
  end

  shared_examples "a page in history mode" do
    before { visit path }

    it "displays the history notice text" do
      expect(page).to have_text("This was published under the #{content_item['links']['government'][0]['title']}")
    end
  end

  shared_examples "an RTL page in history mode" do
    before { visit path }

    it "marks up the government name correctly" do
      expect(page).to have_css("span[lang='en'][dir='ltr']", text: content_item["links"]["government"][0]["title"])
    end
  end

  context "when content item is from Content Store" do
    let(:content_item) { content_store_has_example_item(path, schema: :news_article) }
    let(:path) { "/government/news/christmas-2016-prime-ministers-message" }

    it_behaves_like "a news article page"

    context "when content item has an image caption" do
      let(:path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations" }
      let(:content_item) { content_store_has_example_item(path, schema: :news_article, example: :news_article_with_image_caption) }

      it_behaves_like "a news article page with an image caption"
    end

    context "when content item has a high resolution image" do
      let(:path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations" }
      let(:content_item) { content_store_has_example_item(path, schema: :news_article, example: :news_article_with_image_caption) }

      it_behaves_like "a news article page with a high resolution image"
    end

    context "when visiting a page in history mode" do
      let(:path) { "/government/news/final-care-act-guidance-published" }
      # rubocop:disable RSpec/LetSetup
      let!(:content_item) { content_store_has_example_item(path, schema: :news_article, example: :news_article_history_mode) }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like "a page in history mode"
    end

    context "when visiting an RTL page in history mode" do
      let(:path) { "/government/news/uk-and-us-sanction-key-houthi-figures-to-protect-maritime-security-in-the-red-sea.ar" }
      # rubocop:disable RSpec/LetSetup
      let!(:content_item) { content_store_has_example_item(path, schema: :news_article, example: :news_article_history_mode_translated_arabic) }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like "an RTL page in history mode"
    end
  end

  context "when content item is from Publishing API's GraphQL" do
    let(:content_item) { graphql_has_example_item("news_article") }
    let(:path) { "/government/news/christmas-2016-prime-ministers-message?graphql=true" }

    it_behaves_like "a news article page"

    context "when content item has an image caption" do
      let(:path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations?graphql=true" }
      let(:content_item) { graphql_has_example_item("news_article_with_image_caption") }

      it_behaves_like "a news article page with an image caption"
    end

    context "when content item has a high resolution image" do
      let(:path) { "/government/news/british-high-commission-marks-his-majesty-king-charles-iiis-birthday-with-brilliantly-british-celebrations?graphql=true" }
      let(:content_item) { graphql_has_example_item("news_article_with_image_caption") }

      it_behaves_like "a news article page with a high resolution image"
    end

    context "when visiting a page in history mode" do
      let(:path) { "/government/news/final-care-act-guidance-published?graphql=true" }
      # rubocop:disable RSpec/LetSetup
      let!(:content_item) { graphql_has_example_item("news_article_history_mode") }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like "a page in history mode"
    end

    context "when visiting an RTL page in history mode" do
      let(:path) { "/government/news/uk-and-us-sanction-key-houthi-figures-to-protect-maritime-security-in-the-red-sea.ar?graphql=true" }
      # rubocop:disable RSpec/LetSetup
      let!(:content_item) { graphql_has_example_item("news_article_history_mode_translated_arabic") }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like "an RTL page in history mode"
    end
  end
end
