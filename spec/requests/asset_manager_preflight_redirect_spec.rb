# Exercises ApplicationController#redirect_to_asset_manager_preflight_if_required,
# the before_action every page inherits, using the Help page as a
# representative example of an ordinary content page.
RSpec.describe "Asset Manager preflight redirect" do
  around do |example|
    original = ENV["PLEK_HOSTNAME_PREFIX"]
    example.run
    ENV["PLEK_HOSTNAME_PREFIX"] = original
  end

  context "on a live (non-draft) host" do
    before { ENV["PLEK_HOSTNAME_PREFIX"] = nil }

    it "does not redirect, even without the preflight cookie" do
      content_store_has_random_item(base_path: "/help", schema: "help_page")

      get "/help"

      expect(response).to have_http_status(:ok)
    end
  end

  context "on a draft host" do
    before { ENV["PLEK_HOSTNAME_PREFIX"] = "draft-" }

    context "without the preflight cookie" do
      it "redirects to the Asset Manager preflight page, preserving the original path" do
        get "/help"

        expect(response).to redirect_to("http://www.example.com/draft-asset-preflight?return_to=%2Fhelp")
      end

      it "preserves the query string in the return_to path" do
        get "/help?cache=false"

        expect(response.location).to include(CGI.escape("/help?cache=false"))
      end

      it "forwards arbitrary query params from the original request onto the preflight redirect" do
        get "/help", params: { token: "some-jwt", locale: "cy" }

        redirect_query = CGI.parse(URI.parse(response.location).query)
        expect(redirect_query["token"]).to eq(["some-jwt"])
        expect(redirect_query["locale"]).to eq(["cy"])
      end

      it "never lets a malicious return_to param on the original request survive the round trip" do
        # A same-named return_to on the original request must not collide
        # with, or be mistaken for, the one we set ourselves - and even if
        # it did, AssetManagerPreflightController's own validation is the
        # backstop. Follow the whole redirect chain and check where it
        # actually ends up pointing.
        get "/help", params: { return_to: "https://evil.example.com/phish" }
        follow_redirect!

        expect(response.body).not_to include("evil.example.com")
        expect(response.body).to include('url=/"')
      end
    end

    context "with the preflight cookie already set" do
      it "serves the page as normal" do
        content_store_has_random_item(base_path: "/help", schema: "help_page")
        cookies[:asset_manager_session_invoked] = "1"

        get "/help"

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
