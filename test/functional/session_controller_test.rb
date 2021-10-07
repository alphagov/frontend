require "test_helper"
require "gds_api/test_helpers/account_api"

class SessionsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Requests

  context "GET sign-in" do
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
  end

  context "GET sign-in/callback" do
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
        @ga_client_id = nil
        @cookie_consent = true
      end

      context "with no extra parameters" do
        setup { stub_account_api }

        should "set the 'GOVUK-Account-Session' header" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], @govuk_account_session
        end

        should "redirect to the account home path with cookie_consent=accept" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=accept"
        end

        context "cookie consent is passed by query param" do
          setup do
            @cookie_consent = nil
            stub_account_api
          end

          should "redirect to the account home path with cookie_consent=accept if given" do
            get :callback, params: { code: "code123", state: "state123", cookie_consent: "accept" }

            assert_response :redirect
            assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=accept"
          end

          should "redirect to the account home path with cookie_consent=reject if given" do
            get :callback, params: { code: "code123", state: "state123", cookie_consent: "reject" }

            assert_response :redirect
            assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=reject"
          end

          should "redirect to the account home path with no cookie_consent param if not given" do
            get :callback, params: { code: "code123", state: "state123" }

            assert_response :redirect
            assert_equal @response.redirect_url, account_home_url
          end
        end

        should "redirect with the specified :_ga param" do
          underscore_ga = "underscore_ga"
          get :callback, params: { code: "code123", state: "state123", _ga: underscore_ga }

          assert_response :redirect
          assert_includes @response.redirect_url, underscore_ga
        end

        should "not set the cookies_policy cookie" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_nil cookies[:cookies_policy]
        end

        context "the cookies_policy cookie is set" do
          setup do
            @request.cookies[:cookies_policy] = { usage: "maybe" }.to_json
          end

          should "update the cookies_policy cookie" do
            get :callback, params: { code: "code123", state: "state123" }

            assert_equal "{\"usage\":true}", cookies[:cookies_policy]
          end
        end

        context "the cookies_policy cookie is set to invalid JSON" do
          setup do
            @original_cookies_policy = "not json"
            @request.cookies[:cookies_policy] = @original_cookies_policy
          end

          should "not change the cookies_policy cookie" do
            get :callback, params: { code: "code123", state: "state123" }

            assert_equal @original_cookies_policy, cookies[:cookies_policy]
          end
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
      end

      context "account-api returns a :ga_client_id" do
        setup do
          @ga_client_id = "analytics-client-identifier"
          stub_account_api
        end

        should "redirect with the specified :ga_client_id of the api response if present" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, @ga_client_id
        end

        should "uses the :ga_client_if over the :_ga" do
          underscore_ga = "underscore_ga"
          get :callback, params: { code: "code123", state: "state123", _ga: underscore_ga }

          assert_response :redirect
          assert_not_includes @response.redirect_url, underscore_ga
          assert_includes @response.redirect_url, @ga_client_id
        end
      end

      context "account-api returns a :redirect_path with repeated parameters AND a :ga_client_id" do
        setup do
          @redirect_path = "/bank-holiday?param=first-repeated-parameter&param=second-repeated-parameter"
          @ga_client_id = "analytics-client-identifier"
          stub_account_api
        end

        should "not mangle the repeated parameters" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, "?param=first-repeated-parameter"
          assert_includes @response.redirect_url, "&param=second-repeated-parameter"
          assert_includes @response.redirect_url, "&_ga=#{@ga_client_id}"
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

  def stub_account_api
    stub_account_api_validates_auth_response(
      govuk_account_session: @govuk_account_session,
      redirect_path: @redirect_path,
      ga_client_id: @ga_client_id,
      cookie_consent: @cookie_consent,
    )
  end
end
