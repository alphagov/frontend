RSpec.describe "Developer Flags: HTTP Caching" do
  include ContentStoreHelpers

  context "when no_http_caching is requested" do
    before { Rails.application.config.no_http_caching = true }
    after { Rails.application.config.no_http_caching = false }

    context "when loading a content_item" do
      before { stub_homepage_content_item }

      it "does not set expiry headers" do
        get "/"

        expect(response).not_to honour_content_store_ttl
      end
    end

    context "when loading a route with no content_item" do
      before { content_store_has_random_item(base_path: "/roadmap", schema: "special_route") }

      it "does not set expiry headers" do
        get "/roadmap"

        expect(response.headers["Cache-Control"]).to eq("max-age=0, private, must-revalidate")
      end
    end
  end
end
