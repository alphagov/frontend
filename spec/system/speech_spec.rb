RSpec.describe "Speech" do
  it_behaves_like "it has meta tags", "speech", "/government/speeches/speech-authored-article"
  it_behaves_like "it has meta tags for images", "speech", "/government/speeches/speech-authored-article"

  context "when visiting a Speeches page" do
    before do
      content_store_has_example_item("/government/speeches/speech-authored-article", schema: :speech, example: "speech-authored-article")
      content_store_has_example_item("/government/speeches/speech", schema: :speech, example: "speech")
    end

    it "displays the speech content" do
      visit "/government/speeches/speech-authored-article"

      expect(page).to have_title("Britain's choice: economic security with the EU, or a leap into the dark (Archived)")

      expect(page).to have_css("h1", text: "Britain's choice: economic security with the EU, or a leap into the dark (Archived)")
      expect(page).to have_text("Prime Minister David Cameron wrote an article on the UK's economic security within the EU for The Telegraph.")
    end

    it "renders metadata and document footer, including speaker" do
      visit "/government/speeches/speech"

      expect(page).to have_css("dt.gem-c-metadata__term", text: "From:")
      expect(page).to have_css("dd.gem-c-metadata__definition", text: "Department of Energy & Climate Change and The Rt Hon Andrea Leadsom MP")
      expect(page).to have_css("dt.gem-c-metadata__term", text: "Published")
      expect(page).to have_css("dd.gem-c-metadata__definition", text: "8 March 2016")

      expect(page).to have_css("dt.app-c-important-metadata__term", text: "Location:")
      expect(page).to have_css("dd.app-c-important-metadata__definition", text: "Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London")
      expect(page).to have_css("dt.app-c-important-metadata__term", text: "Delivered on:")
      expect(page).to have_css("dd.app-c-important-metadata__definition", text: "2 February 2016 (Original script, may differ from delivered version)")

      expect(page).to have_css("div.app-c-published-dates", text: "Published 8 March 2016")
    end

    it "does not display a single page notification button" do
      visit "/government/speeches/speech-authored-article"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end

  context "when visiting a speech translation page" do
    before do
      content_store_has_example_item("/government/speeches/speech-translated", schema: :speech, example: "speech-translated")
    end

    it "translated speech" do
      visit "/government/speeches/speech-translated"

      expect(page).to have_title("هذا القرار بداية لنهاية برنامج الأسلحة الكيميائية في ليبيا")
      expect(page).to have_css(".gem-c-translation-nav")
      expect(page).to have_text("بوريس جونسون: يمنح القرار الترخيص اللازم لمنظمة حظر الأسلحة الكيميائية لإزالة سلائف تلك الأسلحة من ليبيا تمهيدا لإتلافها في بلد ثالث. وبذلك نكون قد خففنا خطر وقوع هذه الأسلحة في أيدي الإرهابيين ")
    end
  end
end
