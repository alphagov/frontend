RSpec.describe "Speech" do
  it_behaves_like "it has meta tags", "speech", "speech-authored-article"
  it_behaves_like "it has meta tags for images", "speech", "speech-authored-article"

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

      within("[class*='metadata-column']") do
        expect(page).to have_text("Department of Energy & Climate Change and The Rt Hon Andrea Leadsom MP")
        expect(page).to have_link("Department of Energy", href: "/government/organisations/department-of-energy-climate-change")
        expect(page).to have_link("The Rt Hon Andrea Leadsom MP", href: "/government/people/andrea-leadsom")
        expect(page).to have_text("Published 8 March 2016")
      end

      within("[class*='important-metadata']") do
        expect(page).to have_text("Delivered on: 2 February 2016 (Original script, may differ from delivered version)")
        expect(page).to have_text("Location: Women in Nuclear UK Conference, Church House Conference Centre, Dean's Yard, Westminster, London")
      end
      expect(page).to have_selector(".gem-c-published-dates", text: "Published 8 March 2016")
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

    it "displays the translated speech" do
      visit "/government/speeches/speech-translated"

      expect(page).to have_title("هذا القرار بداية لنهاية برنامج الأسلحة الكيميائية في ليبيا")
      expect(page).to have_css(".gem-c-translation-nav")
      expect(page).to have_text("بوريس جونسون: يمنح القرار الترخيص اللازم لمنظمة حظر الأسلحة الكيميائية لإزالة سلائف تلك الأسلحة من ليبيا تمهيدا لإتلافها في بلد ثالث. وبذلك نكون قد خففنا خطر وقوع هذه الأسلحة في أيدي الإرهابيين ")
    end
  end

  context "when visiting a speech that is withdrawn" do
    before do
      content_store_has_example_item("/government/speeches/withdrawn-speech", schema: :speech, example: "withdrawn-speech")
    end

    it "displays the withdrawn speech notice" do
      visit "/government/speeches/withdrawn-speech"

      expect(page).to have_css(".govspeak", text: "This page has been withdrawn because it is out of date.")
      expect(page).to have_content("withdrawn on 15 May 2018")
    end
  end

  context "when visiting a speech having speaker without a profile" do
    before do
      content_store_has_example_item("/government/speeches/speech-speaker-without-profile", schema: :speech, example: "speech-speaker-without-profile")
    end

    it "displays the speech content and the speaker without profile metadata" do
      visit "/government/speeches/speech-speaker-without-profile"

      expect(page).to have_title("Queen's Speech 2016 - GOV.UK")
      expect(page).to have_css(".gem-c-metadata__definition", text: "Her Majesty the Queen")
    end
  end
end
