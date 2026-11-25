RSpec.describe "Static Error Pages" do
  context "when asked for a 4xx page" do
    it "renders the appropriate page" do
      visit "/static-error-pages/404.html"

      within "head", visible: :all do
        expect(page).to have_css("title", text: "Page not found - GOV.UK", visible: :all)
      end

      within "body" do
        expect(page).to have_css("#global-cookie-message", visible: :hidden)

        within "#content" do
          expect(page).to have_css("h1", text: "Page not found")
          expect(page).to have_css("pre", text: "Status code: 404", visible: :all)
        end

        within "footer" do
          expect(page).to have_css(".govuk-footer__navigation")
          expect(page).to have_css(".govuk-footer__meta")
        end
      end
    end
  end

  context "when asked for a 5xx page" do
    it "renders the appropriate page" do
      visit "/static-error-pages/500.html"

      within "head", visible: :all do
        expect(page).to have_css("title", text: "Sorry, we’re experiencing technical difficulties - GOV.UK", visible: :all)
      end

      within "body" do
        expect(page).to have_css("#global-cookie-message", visible: :hidden)

        within "#content" do
          expect(page).to have_css("h1", text: "Sorry, we’re experiencing technical difficulties")
          expect(page).to have_css("pre", text: "Status code: 500", visible: :all)
        end

        within "footer" do
          expect(page).to have_css(".govuk-footer__navigation")
          expect(page).to have_css(".govuk-footer__meta")
        end
      end
    end
  end
end
