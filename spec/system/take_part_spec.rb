RSpec.describe "TakePart" do
  before do
    content_store_has_example_item("/government/get-involved/take-part/tp1", schema: :take_part)
  end

  it_behaves_like "it has meta tags", "take_part", "take_part"
  it_behaves_like "it has meta tags for images", "take_part", "take_part"

  context "when visiting a Take Part page" do
    it "displays the take_part page" do
      visit "/government/get-involved/take-part/tp1"

      expect(page).to have_title("Become a councillor - GOV.UK")

      expect(page).to have_css("h1", text: "Become a councillor")
      expect(page).to have_text("All councils are led by democratically elected councillors who set the vision and direction, and represent their local community.")

      assert page.has_text?("There are roughly 20,000 local councillors in England. Councillors are elected to the local council to represent their own local community, so they must either live or work in the area.")
    end

    it "does not display a single page notification button" do
      visit "/government/get-involved/take-part/tp1"

      expect(page).not_to have_css(".gem-c-single-page-notification-button")
    end
  end
end
