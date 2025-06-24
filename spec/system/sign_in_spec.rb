RSpec.describe "Sign in" do
  describe "Sign-in help page" do
    before do
      payload = {
        base_path: "/sign-in",
        format: "special_route",
        title: "Sign in to a service",
        description: "",
        details: {
          body: "",
        },
      }
      stub_content_store_has_item("/sign-in", payload)
    end

    it "renders the sign-in help page correctly" do
      visit "/sign-in"

      expect(page).to have_title("Sign in to a service")

      expect(page).to have_text("Search GOV.UK for a service")
      expect(page).to have_button("Search")
    end

    it "includes search facets as hidden elements" do
      visit "/sign-in"

      expect(page).to have_field("content_purpose_supergroup[]", type: :hidden, with: "services")
    end

    it "includes the most viewed header" do
      visit "/sign-in"

      expect(page).to have_text("Sign in to one of the most viewed services")
    end

    it "includes the most-viewed links" do
      visit "/sign-in"

      expect(page).to have_link("HMRC services", href: "/log-in-register-hmrc-online-services")
    end
  end
end
