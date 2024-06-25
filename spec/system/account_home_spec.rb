RSpec.describe "AccountHome", type: :system do
  before do
    stub_content_store_has_item("/")
  end

  context "/account/home" do
    it "redirects users to One Login's Your Services page" do
      visit(account_home_path)
      expect(page.current_url).to eq("#{GovukPersonalisation::Urls.one_login_your_services}/")
    end

    context "when there are cookie consent and _ga url parameters" do
      it "preserve them through the redirect" do
        visit(account_home_path(cookie_consent: true, _ga: "abc123"))
        expect(page.current_url).to include("cookie_consent=true")
        expect(page.current_url).to include("_ga=abc123")
      end
    end
  end
end
