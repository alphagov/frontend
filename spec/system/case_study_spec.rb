RSpec.describe "CaseStudy" do
  before do
    content_store_has_example_item("/government/case-studies/get-britain-building-carlisle-park", schema: :case_study)
    content_store_has_example_item("/government/case-studies/doing-business-in-spain", schema: :case_study, example: "doing-business-in-spain")
  end

  it_behaves_like "it has meta tags", "case_study", "doing-business-in-spain"
  it_behaves_like "it has meta tags for images", "case_study", "doing-business-in-spain"

  context "when visiting a Case Study page" do
    it "displays the case_study page" do
      visit "/government/case-studies/get-britain-building-carlisle-park"

      expect(page).to have_title("Get Britain Building: Carlisle Park - Case study - GOV.UK")

      expect(page).to have_css("h1", text: "Get Britain Building: Carlisle Park")
      expect(page).to have_text("Nearly 400 homes are set to be built on the site of a former tar distillery thanks to Gleeson Homes and HCA investment.")

      expect(page).to have_css(".gem-c-translation-nav")
    end

    context "when visiting a Withdrawn Case Study page" do
      it "displays the case_study page" do
        visit "/government/case-studies/doing-business-in-spain"

        expect(page).to have_title("[Withdrawn] Doing business in Spain - Case study - GOV.UK")

        expect(page).to have_css("h1", text: "Doing business in Spain")
        expect(page).to have_text("This case study was withdrawn on")
      end
    end

    context "when visiting a Case Study page which is translatable" do
      it "displays the case_study page" do
        visit "/government/case-studies/doing-business-in-spain"

        expect(page).to have_css(".gem-c-translation-nav")
      end
    end

    it "does not display a single page notification button" do
      visit "/government/case-studies/get-britain-building-carlisle-park"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
