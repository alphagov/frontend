require "integration_test_helper"
require "gds_api/test_helpers/account_api"

class SessionsTest < ActionDispatch::IntegrationTest
  include GdsApi::TestHelpers::AccountApi

  %w[level0 level1].each do |level|
    should "allow #{level}" do
      stub = stub_account_api_get_sign_in_url(level_of_authentication: level)

      get "/sign-in", params: { level_of_authentication: level }

      assert_response :redirect
      assert_requested stub
    end
  end

  context "HTTP Referer" do
    should "prefer the redirect_path over the HTTP Referer" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/from-param")

      get "/sign-in", headers: { "Referer" => "#{Plek.new.website_root}/from-referer" }, params: { redirect_path: "/from-param" }

      assert_response :redirect
      assert_requested stub
    end

    should "add a redirect_path param to /sign-in from the HTTP Referer header" do
      stub = stub_account_api_get_sign_in_url(redirect_path: "/transition-check/results?c[]=import-wombats&c[]=practice-wizardry")

      get "/sign-in", headers: { "Referer" => "#{Plek.new.website_root}/transition-check/results?c[]=import-wombats&c[]=practice-wizardry" }

      assert_response :redirect
      assert_requested stub
    end
  end

  context "validation" do
    should "not allow other levels of authentication" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(level_of_authentication: "level2")

      get "/sign-in", params: { level_of_authentication: "level2" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end

    should "not allow protocol-relative redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "//evil")

      get "/sign-in", params: { redirect_path: "//evil" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end

    should "not allow absolute redirects" do
      stub = stub_account_api_get_sign_in_url
      stub_evil = stub_account_api_get_sign_in_url(redirect_path: "http://www.evil.com")

      get "/sign-in", params: { redirect_path: "http://www.evil.com" }

      assert_response :redirect
      assert_requested stub
      assert_not_requested stub_evil
    end
  end
end
