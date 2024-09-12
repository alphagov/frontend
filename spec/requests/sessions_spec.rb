require "gds_api/test_helpers/account_api"

RSpec.describe "Sessions" do
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Requests

  context "GET /account" do
    before { stub_account_api_get_sign_in_url }

    it "redirects the user to the GOV.UK Account service domain" do
      get "/account"

      expect(response).to redirect_to("https://home.account.gov.uk")
    end

    it "preserves the _ga tracking parameter if provided" do
      get "/account", params: { _ga: "ga123" }

      expect(response).to redirect_to("https://home.account.gov.uk?_ga=ga123")
    end

    context "HTTP Referer" do
      context "with a referer on GOV.UK" do
        before do
          @redirect_path = "/transition-check/results?c[]=import-wombats&c[]=practice-wizardry"
          @referer = "#{Plek.new.website_root}#{@redirect_path}"
          setup_referer
        end

        it "uses the path from the referer as the redirect_path" do
          get "/account", headers: { "Referer" => @referer }

          expect(response).to have_http_status(:redirect)
          expect(@stub_with_redirect_path).to have_been_requested
          expect(@stub_without_redirect_path).not_to have_been_requested
        end
      end

      context "with a protocol-relative redirect" do
        before do
          @referer = "//protocol-relative-path"
          @redirect_path = @referer
          setup_referer
        end

        it "does not take the redirect_path from the referer" do
          get "/account", headers: { "Referer" => @referer }

          expect(@stub_with_redirect_path).not_to have_been_requested
          expect(response).to redirect_to("https://home.account.gov.uk")
        end
      end

      context "with a referer from outside GOV.UK" do
        before do
          @referer = "https://www.some-other-website.gov.uk/path"
          @redirect_path = "/path"
          setup_referer
        end

        it "does not take the redirect_path from the referer" do
          get "/account", headers: { "Referer" => @referer }

          expect(@stub_with_redirect_path).not_to have_been_requested
          expect(response).to redirect_to("https://home.account.gov.uk")
        end
      end
    end
  end

  context "GET /sign-in/callback" do
    before { @root_path = Plek.new.website_root }

    it "redirects to the root path if the :code param is not present" do
      get "/sign-in/callback", params: { state: "state123" }

      expect(response).to redirect_to(@response.redirect_url)
    end

    it "redirects to the root path if the :state param is not present" do
      get "/sign-in/callback", params: { code: "code123" }

      expect(response).to redirect_to(@response.redirect_url)
    end

    it "responds with :bad_request if :code or :state are invalid" do
      stub_account_api_rejects_auth_response
      get "/sign-in/callback", params: { code: "code123", state: "state123" }

      expect(response).to have_http_status(:bad_request)
    end

    context "the :code and :state are valid" do
      before do
        @govuk_account_session = "new-session-id"
        @redirect_path = nil
        @cookie_consent = true
        @feedback_consent = true
      end

      context "with no extra parameters" do
        before { stub_account_api }

        it "sets the 'GOVUK-Account-Session' header" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(@govuk_account_session).to eq(@response.headers["GOVUK-Account-Session"])
        end

        it "redirects to the account home path" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(response).to have_http_status(:redirect)
          expect(account_home_url).to eq(@response.redirect_url)
        end

        context "cookie consent is passed by query param" do
          it "redirects to the account home path with cookie_consent=accept if given" do
            get "/sign-in/callback", params: { code: "code123", state: "state123", cookie_consent: "accept" }

            expect(response).to have_http_status(:redirect)
            expect("#{account_home_url}?cookie_consent=accept").to eq(@response.redirect_url)
          end
        end

        it "redirects with the specified :_ga param" do
          underscore_ga = "underscore_ga"
          get "/sign-in/callback", params: { code: "code123", state: "state123", _ga: underscore_ga }

          expect(response).to have_http_status(:redirect)
          assert_includes(@response.redirect_url, underscore_ga)
        end
      end

      context "account-api returns a :redirect_path" do
        before do
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        it "redirects to the redirect path" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(response).to have_http_status(:redirect)
          assert_includes(@response.redirect_url, @redirect_path)
        end

        context "the redirect path has a querystring" do
          before do
            @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
            stub_account_api
          end

          it "preserves the querystring" do
            get "/sign-in/callback", params: { code: "code123", state: "state123" }

            expect(response).to have_http_status(:redirect)
            assert_includes(@response.redirect_url, @redirect_path)
          end
        end
      end

      context "account-api returns a nil :cookie_consent" do
        before do
          @cookie_consent = nil
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        it "signs the user in properly" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(@govuk_account_session).to eq(@response.headers["GOVUK-Account-Session"])
        end

        it "redirects to the redirect_path" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(response).to have_http_status(:redirect)
          assert_includes(@response.redirect_url, @redirect_path)
        end
      end

      context "account-api returns a nil :feedback_consent" do
        before do
          @feedback_consent = nil
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        it "signs the user in properly" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(@govuk_account_session).to eq(@response.headers["GOVUK-Account-Session"])
        end

        it "redirects to the redirect_path" do
          get "/sign-in/callback", params: { code: "code123", state: "state123" }

          expect(response).to have_http_status(:redirect)
          assert_includes(@response.redirect_url, @redirect_path)
        end
      end
    end
  end

  context "GET /sign-out" do
    context "when the user is logged in" do
      before do
        @end_session_uri = "https://authentication-provider/end-session"
        stub_account_api_get_end_session_url(end_session_uri: @end_session_uri)
      end

      # TODO: The request module for govuk_personalisation doesn't support requests correctly,
      #       so we replace the mock_logged_in_session method call with this. We should probably
      #       update the gem to provide a "mock_logged_in_headers" method that we can call here
      it "sets the 'GOVUK-Account-End-Session' header to 1" do
        get "/sign-out", headers: { "GOVUK-Account-Session" => GovukPersonalisation::Flash.encode_session("placeholder", nil) }

        expect(response).to have_header("GOVUK-Account-End-Session")
      end

      it "redirects to the end session URL" do
        get "/sign-out"

        expect(response).to have_http_status(:redirect)
        expect(@end_session_uri).to eq(@response.redirect_url)
      end
    end
  end

  def setup_referer
    @stub_without_redirect_path = stub_account_api_get_sign_in_url
    @stub_with_redirect_path = stub_account_api_get_sign_in_url(redirect_path: @redirect_path)
  end

  def stub_account_api
    stub_account_api_validates_auth_response(
      govuk_account_session: @govuk_account_session,
      redirect_path: @redirect_path,
      cookie_consent: @cookie_consent,
      feedback_consent: @feedback_consent,
    )
  end
end
