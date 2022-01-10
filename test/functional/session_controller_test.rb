require "test_helper"
require "gds_api/test_helpers/account_api"

class SessionsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include GovukPersonalisation::TestHelpers::Requests

  context "GET /sign-in/redirect" do
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

        should "redirect to the account home path with cookie_consent=accept" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=accept"
        end

        context "cookie consent is passed by query param" do
          should "redirect to the account home path with cookie_consent=accept if given" do
            get :callback, params: { code: "code123", state: "state123", cookie_consent: "accept" }

            assert_response :redirect
            assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=accept"
          end

          context "stored cookie consent does not match the query param" do
            should "update the stored consent" do
              stub = stub_account_api_set_attributes(attributes: { cookie_consent: false })

              get :callback, params: { code: "code123", state: "state123", cookie_consent: "reject" }

              assert_response :redirect
              assert_equal @response.redirect_url, "#{account_home_url}?cookie_consent=reject"
              assert_requested stub
            end
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

        should "not sign the user in properly" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], "!#{@govuk_account_session}"
        end

        should "redirect to the consent form, passing along the original redirect_path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, "/sign-in/first-time"
          assert_includes @response.redirect_url, "redirect_path=#{@redirect_path}"
        end
      end

      context "account-api returns a nil :feedback_consent" do
        setup do
          @feedback_consent = nil
          @redirect_path = "/bank-holiday"
          stub_account_api
        end

        should "not sign the user in properly" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_equal @response.headers["GOVUK-Account-Session"], "!#{@govuk_account_session}"
        end

        should "render the consent form, passing along the original redirect_path" do
          get :callback, params: { code: "code123", state: "state123" }

          assert_response :redirect
          assert_includes @response.redirect_url, "/sign-in/first-time"
          assert_includes @response.redirect_url, "redirect_path=#{@redirect_path}"
        end
      end
    end
  end

  context "POST /sign-in/first-time" do
    should "return a 400 error if the :govuk_account_session is missing" do
      post :first_time_post, params: { redirect_path: "https://www.example.com" }
      assert_response :bad_request
    end

    should "return a 400 error if the :govuk_account_session does not start with a '!'" do
      mock_logged_in_session "foo"
      post :first_time_post, params: { redirect_path: "https://www.example.com" }
      assert_response :bad_request
    end

    context "there is a valid :govuk_account_session" do
      setup { mock_logged_in_session "!foo" }

      should "save the consents, sign the user in, and send them to the redirect path" do
        stub_account_api_set_attributes(
          attributes: {
            cookie_consent: true,
            feedback_consent: true,
          },
          govuk_account_session: "foo",
          new_govuk_account_session: "bar",
        )

        post :first_time_post, params: { redirect_path: "/account/home", cookie_consent: "yes", feedback_consent: "yes" }
        assert_response :redirect
        assert_includes @response.redirect_url, "/account/home?cookie_consent=accept"
        assert_equal @response.headers["GOVUK-Account-Session"], "bar"
      end

      should "preserve a querystring in the redirect path" do
        stub_account_api_set_attributes(
          attributes: {
            cookie_consent: true,
            feedback_consent: true,
          },
          govuk_account_session: "foo",
          new_govuk_account_session: "bar",
        )

        redirect_path = "/email/subscriptions/account/confirm?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
        get :first_time_post, params: { redirect_path: redirect_path, cookie_consent: "yes", feedback_consent: "yes" }

        assert_response :redirect
        assert_includes @response.redirect_url, "#{redirect_path}&cookie_consent=accept"
      end

      should "return a 400 error if the :redirect_path is invalid" do
        post :first_time_post, params: { redirect_path: "https://www.example.com" }
        assert_response :bad_request
      end

      should "display an error message if the cookie consent is invalid" do
        post :first_time_post, params: { redirect_path: "/account/home", cookie_consent: "nonsense" }
        assert_includes @response.body, I18n.t("sessions.first_time.cookie_consent.field.invalid")
      end

      should "display an error message if the feedback consent is invalid" do
        post :first_time_post, params: { redirect_path: "/account/home", cookie_consent: "yes", feedback_consent: "nonsense" }
        assert_includes @response.body, I18n.t("sessions.first_time.feedback_consent.field.invalid")
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
      cookie_consent: @cookie_consent,
      feedback_consent: @feedback_consent,
    )
  end
end
