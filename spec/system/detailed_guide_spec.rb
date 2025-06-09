RSpec.describe "DetailedGuide" do
  it_behaves_like "it has meta tags", "detailed_guide", "detailed_guide"
  it_behaves_like "it has meta tags for images", "detailed_guide", "detailed_guide"

  context "when visiting a detailed guide page" do
    before do
      content_store_has_example_item("/guidance/salary-sacrifice-and-the-effects-on-paye", schema: :detailed_guide, example: "detailed_guide")
    end

    it "displays the guidance page" do
      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(page).to have_title("Salary sacrifice")

      expect(page).to have_css("h1", text: "Salary sacrifice")
      expect(page).to have_text("Find out how salary sacrifice arrangements work and how they might affect an employee's current and future income.")
    end

    it "renders the relevant metadata" do
      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"
      within("[class*='metadata-column']") do
        expect(page).to have_text("From: HM Revenue & Customs")
        expect(page).to have_link("HM Revenue & Customs", href: "/government/organisations/hm-revenue-customs")
        expect(page).to have_text("Published 12 June 2014")
        expect(page).to have_text("Last updated 18 February 2016")
      end
    end

    it "renders back to contents elements" do
      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(page).to have_css(".gem-c-back-to-top-link[href='#contents']")
    end
  end

  # context "when visiting a withdrawn detailed guide page" do
  #   before do
  #     content_store_has_example_item("/guidance/eu-rules-on-the-use-of-chemicals", schema: :detailed_guide, example: "withdrawn_detailed_guide")
  #   end
  #   it "displays withdrawn detailed guide page" do
  #     visit "/guidance/eu-rules-on-the-use-of-chemicals"

  #     expect(page).to have_css(".govspeak", text: "This page has been withdrawn because it is out of date.")
  #     expect(page).to have_content("withdrawn on 28 January 2015")
  #   end
  # end
end
