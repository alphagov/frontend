require "test_helper"
require "gds_api/test_helpers/account_api"

class SessionsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Requests

  context "GET /account" do
    setup do
      stub_account_api_get_sign_in_url
    end

    should "redirect the user to the GOV.UK Account service domain" do
      get :create
      assert_response :redirect
      assert_equal @response.headers["Location"], "http://auth/provider"
    end

    should "preserve the _ga tracking parameter if provided" do
      get :create, params: { _ga: "ga123" }
      assert_equal @response.headers["Location"], "http://auth/provider?_ga=ga123"
    end

    context "HTTP Referer" do
      context "with a referer on GOV.UK" do
        setup do
          @redirect_path = "/transition-check/results?c[]=import-wombats&c[]=practice-wizardry"
          @referer = "#{Plek.new.website_root}#{@redirect_path}"
          setup_referer
        end

        should "uses the path from the referer as the redirect_path" do
          get :create

          assert_response :redirect
          assert_requested @stub_with_redirect_path
          assert_not_requested @stub_without_redirect_path
        end
      end

      context "with a protocol-relative redirect" do
        setup do
          @referer = "//protocol-relative-path"
          @redirect_path = @referer
          setup_referer
        end

        should "not take the redirect_path from the referer" do
          get :create

          assert_response :redirect
          assert_not_requested @stub_with_redirect_path
          assert_requested @stub_without_redirect_path
        end
      end

      context "with a referer from outside GOV.UK" do
        setup do
          @referer = "https://www.some-other-website.gov.uk/path"
          @redirect_path = "/path"
          setup_referer
        end

        should "not take the redirect_path from the referer" do
          get :create

          assert_response :redirect
          assert_not_requested @stub_with_redirect_path
          assert_requested @stub_without_redirect_path
        end
      end
    end
  end

  context "GET /sign-in/callback" do
    setup do
      @root_path = Plek.new.website_root
    end

    should "redirect to the root path if the :code param is not present" do
      get :callback, params: { state: "state123" }

      assert_response :redirect
      assert_equal @response.redirect_url, @root_path
    end

    should "redirect to the root path if the :state param is not present" do
      get :callback, params: { code: "code123" }

      assert_response :redirect
      assert_equal @response.redirect_url, @root_path
    end

    should "respond with :bad_request if :code or :state are invalid" do
      stub_account_api_rejects_auth_response
      get :callback, params: { code: "code123", state: "state123" }

      assert_response :bad_request
    end

    context "the :code and :state are valid" do
      setup do
        @govuk_account_session = "new-session-id"
        @redirect_path = nil
        @cookie_consent = true
        @feedback_consent = true
      end

      context "with no extra parameters" do
        setup { stub_account_api }

        should "set the 'GOVUK-Account-Session' header" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], @govuk_account_session
        end

        should "redirect to the account home path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_equal @response.redirect_url, account_home_url
        end

        context "cookie consent is passed by query param" do
          should "redirect to the account home path with cookie_consent=accept if given" do
            get :callback, params: { code: "code123", state: "state123", cookie_consent: "accept" }

            assert_response :redirect
            assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=accept"
          end
        end

        should "redirect with the specified :_ga param" do
          underscore_ga = "underscore_ga"
          get :callback, params: { code: "code123", state: "state123", _ga: underscore_ga }

          assert_response :redirect
          assert_includes @response.redirect_url, underscore_ga
        end
      end

      context "account-api returns a :redirect_path" do
        setup do
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        should "redirect to the redirect path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, @redirect_path
        end

        context "the redirect path has a querystring" do
          setup do
            @redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
            stub_account_api
          end

          should "preserve the querystring" do
            get :callback, params: { code: "code123", state: "state123" }

            assert_response :redirect
            assert_includes @response.redirect_url, @redirect_path
          end
        end
      end

      context "account-api returns a nil :cookie_consent" do
        setup do
          @cookie_consent = nil
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        should "sign the user in properly" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], @govuk_account_session
        end

        should "redirect to the redirect_path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, @redirect_path
        end
      end

      context "account-api returns a nil :feedback_consent" do
        setup do
          @feedback_consent = nil
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        should "sign the user in properly" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], @govuk_account_session
        end

        should "redirect to the redirect_path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, @redirect_path
        end
      end
    end
  end

  context "GET /sign-out" do
    context "when the user is logged in" do
      setup do
        @end_session_uri = "https://authentication-provider/end-session"
        mock_logged_in_session
        stub_account_api_get_end_session_url(end_session_uri: @end_session_uri)
      end

      should "set the 'GOVUK-Account-End-Session' header to 1" do
        get :delete
        assert @response.headers["GOVUK-Account-End-Session"].present?
      end

      should "redirect to the end session URL" do
        get :delete
        assert_response :redirect
        assert_equal @response.redirect_url, @end_session_uri
      end
    end
  end

  def setup_referer
    @stub_without_redirect_path = stub_account_api_get_sign_in_url
    @stub_with_redirect_path = stub_account_api_get_sign_in_url(redirect_path: @redirect_path)
    @request.headers["Referer"] = @referer
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
