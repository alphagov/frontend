RSpec.describe "Answer" do
  include SchemaOrgHelpers

  before do
    content_store_has_example_item("/gwasanaethau-ar-lein-cymraeg-cthem", schema: :answer, example: "answer")
    content_store_has_example_item("/contact-hmrc", schema: :answer, example: "answer-english-hmrc")
  end

  context "when visiting an answer page" do
    it "renders answer title and body" do
      visit "/gwasanaethau-ar-lein-cymraeg-cthem"

      expect(page).to have_title("Gwasanaethau ar-lein Cyllid a Thollau EM yn y Gymraeg")
      expect(page).to have_css("h1", text: "Gwasanaethau ar-lein Cyllid a Thollau EM yn y Gymraeg")
      expect(page).to have_text("Bydd angen cod cychwyn arnoch i ddechrau defnyddio’r holl wasanaethau hyn, ac eithrio TAW. Anfonir hwn atoch cyn pen saith diwrnod gwaith ar ôl i chi gofrestru. Os ydych chi’n byw dramor, gall gymryd hyd at 21 diwrnod i gyrraedd.")
    end

    it "renders related links correctly" do
      visit "/gwasanaethau-ar-lein-cymraeg-cthem"

      first_related_link = {
        title: "Gwasanaethau ar-lein",
        url: "https://online.hmrc.gov.uk/login?lang=cym",
      }

      within(".gem-c-related-navigation") do
        expect(page).to have_css(".gem-c-related-navigation__section-link--other[href=\"#{first_related_link[:url]}\"]", text: first_related_link[:title])
      end
    end

    it "renders FAQ structured data" do
      visit "/gwasanaethau-ar-lein-cymraeg-cthem"

      faq_schema = find_schema_of_type("FAQPage")

      expect(faq_schema["name"]).to eq("Gwasanaethau ar-lein Cyllid a Thollau EM yn y Gymraeg")
      expect(faq_schema["mainEntity"]).not_to eq([])
    end

    it "does not display a single page notification button" do
      visit "/gwasanaethau-ar-lein-cymraeg-cthem"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end

    it "renders english answer page correctly" do
      visit "/contact-hmrc"

      expect(page).to have_title("Contact HMRC - GOV.UK")
      expect(page).to have_css("h1", text: "Contact HMRC")
      expect(page).to have_text("Get contact details if you have a query about")
    end
  end
end
