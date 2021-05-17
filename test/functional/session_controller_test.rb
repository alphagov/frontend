require "test_helper"
require "gds_api/test_helpers/account_api"

class SessionsControllerTest < ActionController::TestCase
  include GdsApi::TestHelpers::AccountApi
  include SessionHelpers

  context "GET sign-in" do
    setup do
      stub_account_api_get_sign_in_url(redirect_path: "/bank-holiday", state_id: "state123")
    end

    should "redirect the user to the GOV.UK Account service domain" do
      get :create, params: { redirect_path: "/bank-holiday", state_id: "state123" }
      assert_response :redirect
      assert_equal @response.headers["Location"], "http://auth/provider"
    end

    should "preserve the _ga tracking parameter if provided" do
      get :create, params: { redirect_path: "/bank-holiday", state_id: "state123", _ga: "ga123" }
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

    should "set the 'GOVUK-Account-Session' header" do
      stub_account_api_validates_auth_response(govuk_account_session: "placeholder")
      get :callback, params: { code: "code123", state: "state123" }

      assert_equal @response.headers["GOVUK-Account-Session"], "placeholder"
    end

    should "redirect to the redirect path if a redirect path is in the account-api response" do
      stub_account_api_validates_auth_response(redirect_path: "/bank-holiday")
      get :callback, params: { code: "code123", state: "state123" }

      assert_response :redirect
      assert_includes @response.redirect_url, "/bank-holiday"
    end

    should "redirect to the account manager url if no redirect path is in the account-api response" do
      stub_account_api_validates_auth_response(redirect_path: nil, ga_client_id: nil)
      get :callback, params: { code: "code123", state: "state123" }

      assert_response :redirect
      assert_equal @response.redirect_url, Plek.find("account-manager")
    end

    should "redirect with the specified :ga_client_id of the api response if present" do
      ga_client_id = "ga_client_id"
      stub_account_api_validates_auth_response(ga_client_id: ga_client_id)
      get :callback, params: { code: "code123", state: "state123" }

      assert_response :redirect
      assert_includes @response.redirect_url, ga_client_id
    end

    should "redirect with the specified :_ga param if :ga_client_id of the api response is not present" do
      underscore_ga = "underscore_ga"
      stub_account_api_validates_auth_response(ga_client_id: nil)
      get :callback, params: { code: "code123", state: "state123", _ga: underscore_ga }

      assert_response :redirect
      assert_includes @response.redirect_url, underscore_ga
    end

    should "respond with :bad_request if :code or :state are invalid" do
      stub_account_api_rejects_auth_response
      get :callback, params: { code: "code123", state: "state123" }

      assert_response :bad_request
    end
  end

  context "GET /sign-out" do
    context "when the user is logged in" do
      setup do
        mock_logged_in_session
      end

      should "set the 'GOVUK-Account-End-Session' header to 1" do
        get :delete
        assert @response.headers["GOVUK-Account-End-Session"].present?
      end
    end
  end
end
