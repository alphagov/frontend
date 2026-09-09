# Exercises ApplicationController#redirect_to_asset_manager_preflight_if_required,
# the before_action every page inherits, using the Help page as a
# representative example of an ordinary content page.
RSpec.describe "Asset Manager preflight redirect" do
  around do |example|
    original = ENV["PLEK_HOSTNAME_PREFIX"]
    example.run
    ENV["PLEK_HOSTNAME_PREFIX"] = original
  end

  context "when on a live (non-draft) host" do
    before { ENV["PLEK_HOSTNAME_PREFIX"] = nil }

    it "does not redirect, even without a warm preflight session" do
      content_store_has_random_item(base_path: "/help", schema: "help_page")

      get "/help"

      expect(response).to have_http_status(:ok)
    end
  end

  context "when on a draft host" do
    before { ENV["PLEK_HOSTNAME_PREFIX"] = "draft-" }

    context "without a warm preflight session" do
      it "redirects to the Asset Manager preflight page, preserving the original path" do
        get "/help"

        expect(response).to redirect_to("http://www.example.com/draft-asset-preflight?return_to=%2Fhelp")
      end

      it "preserves the query string in the return_to path" do
        get "/help?cache=false"

        expect(response.location).to include(URI.encode_www_form_component("/help?cache=false"))
      end

      it "ignores any `return_to` parameter that may be present in the original request" do
        get "/help?return_to=/dodgy-url"

        expect(response.location).to include(URI.encode_www_form_component("/help"))
        expect(response.location).not_to include("dodgy-url")
      end

      it "forwards arbitrary query params from the original request onto the preflight redirect" do
        get "/help", params: { token: "some-jwt", locale: "cy" }

        redirect_query = Rack::Utils.parse_nested_query(URI.parse(response.location).query)
        expect(redirect_query["token"]).to eq("some-jwt")
        expect(redirect_query["locale"]).to eq("cy")
      end

      it "redirects back to the original path after the preflight" do
        get "/help"
        follow_redirect!

        redirect_path = response.body.match(
          %r{<meta http-equiv="refresh" content="4;url=(/[^"]*)">},
        )[1]

        expect(redirect_path).to eq("/help")
      end
    end

    context "with a warm preflight session" do
      it "serves the page as normal, without redirecting to the preflight page again" do
        content_store_has_random_item(base_path: "/help", schema: "help_page")

        get "/draft-asset-preflight" # warms up the session, as a real preflight visit would
        get "/help"

        expect(response).to have_http_status(:ok)
      end
    end

    context "with a preflight session that has gone stale" do
      it "redirects to the preflight page again" do
        content_store_has_random_item(base_path: "/help", schema: "help_page")

        travel_to 40.minutes.ago do
          get "/draft-asset-preflight" # warms up the session 40 minutes ago - older than the 30 minute TTL
        end

        get "/help"

        expect(response).to redirect_to("http://www.example.com/draft-asset-preflight?return_to=%2Fhelp")
      end
    end
  end
end
