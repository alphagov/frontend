RSpec.describe "AccountHome" do
  before do
    content_item = GovukSchemas::Example.find("homepage", example_name: "homepage_with_popular_links_on_govuk")
    base_path = content_item.fetch("base_path")
    stub_content_store_has_item(base_path, content_item)
  end

  context "/account/home" do
    it "redirects users to One Login's Your Services page" do
      visit account_home_path

      expect(page.current_url).to eq("#{GovukPersonalisation::Urls.one_login_your_services}/")
    end

    context "when there are cookie consent and _ga url parameters" do
      it "preserve them through the redirect" do
        visit account_home_path(cookie_consent: true, _ga: "abc123")

        expect(page.current_url).to include("cookie_consent=true")
        expect(page.current_url).to include("_ga=abc123")
      end
    end
  end
end
