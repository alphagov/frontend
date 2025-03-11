RSpec.describe "Fatality Notice" do
  before do
    content_store_has_example_item("/government/fatalities/sir-george-pomeroy-colley", schema: :fatality_notice)
  end

  it_behaves_like "it has meta tags", "fatality_notice", "fatality_notice"

  context "with a default fatality notice" do
    before { visit "/government/fatalities/sir-george-pomeroy-colley" }

    it "has a title" do
      expect(page).to have_title("Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK")
    end

    it "has a heading" do
      expect(page).to have_css("h1", text: "Sir George Pomeroy Colley killed in Boer War")
    end

    it "has body text" do
      expect(page).to have_text("It is with great sadness that the Ministry of Defence must confirm that Sir George Pomeroy Colley, died in battle in Zululand on 27 February 1881")
    end

    it "has a field of operation" do
      expect(page).to have_text("Field of operation: Zululand")
    end
  end

  context "when the fatality notice has a minister" do
    before do
      content_store_has_example_item("/government/fatalities/sir-george-pomeroy-colley", schema: :fatality_notice, example: :fatality_notice_with_minister)
      visit "/government/fatalities/sir-george-pomeroy-colley"
    end

    it "mentions the minister in the metadata" do
      expect(page).to have_text("The Rt Hon Sir Eric Pickles MP")
    end
  end

  context "when the fatality notice is withdrawn" do
    before do
      content_store_has_example_item("/government/fatalities/sir-george-pomeroy-colley", schema: :fatality_notice, example: :withdrawn_fatality_notice)
      visit "/government/fatalities/sir-george-pomeroy-colley"
    end

    it "has withdrawn text on the title" do
      expect(page).to have_title("[Withdrawn] Sir George Pomeroy Colley killed in Boer War - Fatality notice - GOV.UK")
    end

    it "has a withdrawn notice" do
      within ".gem-c-notice" do
        expect(page).to have_text("This fatality notice was withdrawn on 14 September 2016")
        expect(page).to have_text("This content is not factually correct. For current information please go to")
      end
    end
  end
end
