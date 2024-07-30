RSpec.describe "Help" do
  context "rendering the help index page" do
    before do
      payload = {
        base_path: "/help",
        format: "special_route",
        title: "Help using GOV.UK",
        description: "",
      }
      stub_content_store_has_item("/help", payload)
    end

    it "renders the help index page correctly" do
      visit "/help"

      expect(page).to have_title("Help using GOV.UK")
    end
  end
end
