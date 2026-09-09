RSpec.describe "Asset Manager preflight" do
  around do |example|
    original = ENV["PLEK_HOSTNAME_PREFIX"]
    example.run
    ENV["PLEK_HOSTNAME_PREFIX"] = original
  end

  describe "GET /draft-asset-preflight" do
    context "when on the live host" do
      before { ENV["PLEK_HOSTNAME_PREFIX"] = nil }

      it "returns a 404" do
        get "/draft-asset-preflight"

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when on the draft host" do
      before { ENV["PLEK_HOSTNAME_PREFIX"] = "draft-" }

      it "responds successfully without a layout" do
        get "/draft-asset-preflight"

        expect(response).to have_http_status(:ok)
      end

      it "records in the session that a session has just been warmed up" do
        travel_to Time.zone.at(1_700_000_000) do
          get "/draft-asset-preflight"
        end

        expect(session[:asset_manager_session_set_up]).to eq(1_700_000_000)
      end

      it "sets no-store cache headers" do
        get "/draft-asset-preflight"

        expect(response.headers["Cache-Control"]).to eq("no-store")
      end

      it "loads a placeholder asset from the draft assets host" do
        get "/draft-asset-preflight"

        expect(response.body).to include(
          "#{Plek.find('draft-assets')}/media/5e59279b86650c53b2cefbfe/placeholder.jpg",
        )
      end

      it "forwards an auth bypass token onto the placeholder asset request" do
        get "/draft-asset-preflight", params: { token: "some-jwt" }

        expect(response.body).to include(
          "#{Plek.find('draft-assets')}/media/5e59279b86650c53b2cefbfe/placeholder.jpg?token=some-jwt",
        )
      end

      it "forwards any and all other query params onto the placeholder asset request too" do
        get "/draft-asset-preflight", params: { token: "some-jwt", foo: "bar", locale: "cy" }

        asset_request = response.body[%r{#{Regexp.escape(Plek.find('draft-assets'))}/media/\S+placeholder\.jpg\?[^"]+}]
        expect(asset_request).to be_present
        # The HTML output entity-escapes "&" as "&amp;" between query params -
        # undo that before parsing the query string back out.
        query = Rack::Utils.parse_nested_query(
          URI.parse(CGI.unescapeHTML(asset_request)).query,
        )
        expect(query).to eq("token" => "some-jwt", "foo" => "bar", "locale" => "cy")
      end

      it "percent-encodes forwarded params rather than interpolating them raw" do
        get "/draft-asset-preflight", params: { foo: "a b&c" }

        expect(response.body).to include("foo=a+b%26c")
      end

      it "never forwards return_to onto the placeholder asset request" do
        get "/draft-asset-preflight", params: { return_to: "/somewhere", token: "some-jwt" }

        asset_request = response.body[%r{#{Regexp.escape(Plek.find('draft-assets'))}/media/\S+placeholder\.jpg\?[^"]+}]
        expect(asset_request).not_to include("return_to")
      end

      it "redirects back to the given return_to path once loaded" do
        get "/draft-asset-preflight", params: { return_to: "/government/news/an-example" }

        expect(response.body).to include("url=/government/news/an-example")
        expect(response.body).to include('"/government/news/an-example"')
      end

      it "falls back to the root path when no return_to is given" do
        get "/draft-asset-preflight"

        expect(response.body).to include('url=/"')
      end

      it "refuses to redirect back to another host" do
        get "/draft-asset-preflight", params: { return_to: "https://evil.example.com/phish" }

        expect(response.body).not_to include("evil.example.com")
        expect(response.body).to include('url=/"')
      end

      it "refuses to redirect back to a protocol-relative URL" do
        get "/draft-asset-preflight", params: { return_to: "//evil.example.com/phish" }

        expect(response.body).not_to include("evil.example.com")
        expect(response.body).to include('url=/"')
      end
    end
  end
end
