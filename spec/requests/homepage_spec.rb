RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers

  context "loading the homepage" do
    let(:overrides) { {} }

    before do
      content_store_has_example_item(
        "/",
        schema: "homepage",
        example: "homepage_with_popular_links_on_govuk",
        overrides:,
      )
    end

    it "responds with success" do
      get "/"

      expect(response).to have_http_status(:ok)
    end

    it "sets correct expiry headers" do
      get "/"

      honours_content_store_ttl
    end

    context "with popular links in the content item" do
      it "shows popular links" do
        get "/"

        expect(response.body).to match("title1")
        expect(response.body).to match("url1.com")
        expect(response.body).to match("title2")
        expect(response.body).to match("url2.com")
        expect(response.body).to match("title3")
        expect(response.body).to match("url3.com")
        expect(response.body).to match("title4")
        expect(response.body).to match("url4.com")
        expect(response.body).to match("title5")
        expect(response.body).to match("url5.com")
        expect(response.body).to match("title6")
        expect(response.body).to match("url6.com")
      end
    end

    context "with popular links not in the content item" do
      let(:overrides) { { "links" => {} } }

      it "shows popular links" do
        get "/"

        I18n.t("homepage.index.popular_links").each do |item|
          expect(response.body).to match(item[:title])
        end
      end
    end
  end
end
