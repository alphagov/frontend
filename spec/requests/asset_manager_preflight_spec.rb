RSpec.describe "Asset Manager preflight" do
  describe "GET /draft-asset-preflight" do
    it "responds successfully without a layout" do
      get "/draft-asset-preflight"

      expect(response).to have_http_status(:ok)
    end

    it "sets a short-lived cookie recording that a session has been warmed up" do
      get "/draft-asset-preflight"

      expect(response.cookies["asset_manager_session_invoked"]).to eq("1")
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
      query = CGI.parse(URI.parse(CGI.unescapeHTML(asset_request)).query)
      expect(query).to eq("token" => ["some-jwt"], "foo" => ["bar"], "locale" => ["cy"])
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

      expect(response.body).to include('url=/government/news/an-example')
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

    # The whole point of this page is to wait for the Asset Manager/Signon
    # redirect chain to actually finish before sending the user back - see
    # WHIT-3992. These pin down the two things that make that true, so a
    # future edit doesn't quietly reintroduce a race or a too-eager fallback.
    describe "waiting for the placeholder asset to actually finish loading" do
      it "only requests the placeholder asset directly (no JS) as a <noscript> fallback" do
        get "/draft-asset-preflight"

        noscript_start = response.body.index("<noscript>")
        noscript_end = response.body.index("</noscript>")
        script_start = response.body.index("<script")
        expect(noscript_start).to be_present
        # The eagerly-loading <img> tag must live inside <noscript>, and
        # before the <script> tag that builds its own Image() - otherwise
        # we're back to the original race (the <img> can start, and finish,
        # loading before the script attaches any listener to it).
        expect(noscript_start).to be < noscript_end
        expect(noscript_end).to be < script_start
      end

      it "wires onload/onerror on a freshly-created Image before setting its src" do
        get "/draft-asset-preflight"

        on_load_index = response.body.index("img.onload")
        on_error_index = response.body.index("img.onerror")
        src_index = response.body.index("img.src")

        expect(on_load_index).to be_present
        expect(on_error_index).to be_present
        expect(src_index).to be_present
        expect(on_load_index).to be < src_index
        expect(on_error_index).to be < src_index
      end

      it "has a generous, clearly-last-resort JS fallback timeout" do
        get "/draft-asset-preflight"

        expect(response.body).to include("window.setTimeout(goBack, 10000)")
      end

      it "keeps the no-JS <meta refresh> fallback longer than the JS fallback timeout" do
        get "/draft-asset-preflight"

        expect(response.body).to include('content="12;url=')
      end
    end
  end
end
