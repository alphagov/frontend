RSpec.describe "HelpCookies" do
  context "rendering the cookies setting page" do
    before do
      payload = {
        base_path: "/help/cookies",
        format: "special_route",
        title: "Cookies on GOV.UK",
        description: "You can choose which cookies you're happy for GOV.UK to use.",
      }
      stub_content_store_has_item("/help/cookies", payload)
    end

    it "renders the cookies setting page correctly" do
      visit "/help/cookies"

      within("#content") { expect(page).to have_title("Cookies on GOV.UK") }
    end

    it "has radio buttons set to disable cookies by default" do
      visit "/help/cookies"

      within("#content") do
        expect(page).to have_css("input[name=cookies-usage][value=off][checked]")
        expect(page).to have_css("input[name=cookies-campaigns][value=off][checked]")
        expect(page).to have_css("input[name=cookies-settings][value=off][checked]")
      end
    end
  end
end
