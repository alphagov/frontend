RSpec.describe "HelpPage" do
  before do
    content_store_has_example_item("/help/about-govuk", schema: "help_page", example: "about-govuk")
    content_store_has_example_item("/help/cookie-details", schema: "help_page", example: "cookie-details")
  end

  context "when visiting 'help/:slug'" do
    it "displays the help page using a content item" do
      visit "/help/about-govuk"

      expect(page).to have_title("About GOV.UK - GOV.UK")
      expect(page).to have_css("h1", text: "About GOV.UK")
      expect(page).to have_text("GOV.UK is the website for the UK government. It’s the best place to find government services and information.")
    end
  end

  context "when visiting '/help/cookie-details'" do
    it "sets noindex meta tag" do
      visit "/help/cookie-details"

      expect(page).to have_css('meta[name="robots"][content="noindex"]', visible: false)
    end

    it "does not render with the single page notification button" do
      visit "/help/cookie-details"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
