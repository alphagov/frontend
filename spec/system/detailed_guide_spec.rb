RSpec.describe "DetailedGuide" do
  before do
    content_store_has_example_item("/guidance/salary-sacrifice-and-the-effects-on-paye", schema: :detailed_guide)
  end

  it_behaves_like "it has meta tags", "detailed_guide", "/guidance/salary-sacrifice-and-the-effects-on-paye"
  it_behaves_like "it has meta tags for images", "detailed_guide", "/guidance/salary-sacrifice-and-the-effects-on-paye"

  context "when visiting a detailed guide page" do
    it "displays the guidance page" do
      visit "/guidance/salary-sacrifice-and-the-effects-on-paye"

      expect(page).to have_title("Get Britain Building: Carlisle Park - Case study - GOV.UK")

      expect(page).to have_css("h1", text: "Get Britain Building: Carlisle Park")
      expect(page).to have_text("Nearly 400 homes are set to be built on the site of a former tar distillery thanks to Gleeson Homes and HCA investment.")

      expect(page).to have_css(".gem-c-translation-nav")
    end
  end
end
