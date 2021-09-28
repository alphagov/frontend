require "integration_test_helper"
require "gds_api/test_helpers/account_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi

  context "HTTP Referer" do
    should "add a redirect_path param to /sign-in/redirect from the HTTP Referer header" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/transition-check/results?c[]=import-wombats&c[]=practice-wizardry")

      get "/sign-in/redirect", headers: { "Referer" => "#{Plek.new.website_root}/transition-check/results?c[]=import-wombats&c[]=practice-wizardry" }

      assert_response :redirect
      assert_requested stub
    end

    should "not allow protocol-relative redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "//evil")

      get "/sign-in/redirect", headers: { "Referer" => "//evil" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end

    should "not allow absolute redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "http://www.evil.com")

      get "/sign-in/redirect", headers: { "Referer" => "http://www.evil.com" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end
  end
end
