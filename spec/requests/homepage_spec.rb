RSpec.describe "Homepage" do
  include GovukAbTesting::RspecHelpers

  context "loading the homepage" do
    before { stub_content_store_has_item("/", schema: "special_route", links: {}) }

    it "responds with success" do
      get "/"

      expect(response).to have_http_status(:ok)
    end

    it "sets correct expiry headers" do
      get "/"

      honours_content_store_ttl
    end

    context "with popular links in the content item" do
      setup do
        links = {
          "popular_links" => [
            {
              "details" => {
                "link_items" => [
                  {
                    "title" => "Some popular links title",
                    "url" => "/some/path",
                  },
                ],
              },
            },
          ],
        }
        stub_content_store_has_item("/", schema: "special_route", links:)
      end

      it "shows popular links" do
        get "/"

        expect(response.body).to match("Some popular links title")
      end
    end

    context "with popular links not in the content item" do
      it "shows popular links" do
        get "/"

        I18n.t("homepage.index.popular_links").each do |item|
          expect(response.body).to match(item[:title])
        end
      end
    end
  end
end
