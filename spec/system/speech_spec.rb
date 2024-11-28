RSpec.describe "Speech" do
  it_behaves_like "it has meta tags", "speech", "/government/speeches/speech-authored-article"
  it_behaves_like "it has meta tags for images", "speech", "/government/speeches/speech-authored-article"

  before do
    content_store_has_example_item("/government/speeches/speech-authored-article", schema: :speech, example: "speech-authored-article")
  end

  context "when visiting a Speeches page" do
    it "displays the speech content" do
      visit "/government/speeches/speech-authored-article"

      expect(page).to have_title("Britain's choice: economic security with the EU, or a leap into the dark (Archived)")

      expect(page).to have_css("h1", text: "Britain's choice: economic security with the EU, or a leap into the dark (Archived)")
      expect(page).to have_text("Prime Minister David Cameron wrote an article on the UK's economic security within the EU for The Telegraph.")
    end

    it "does not display a single page notification button" do
      visit "/government/speeches/speech-authored-article"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
