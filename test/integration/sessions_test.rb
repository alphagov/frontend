require "integration_test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  context "when logged in" do
    should "redirect the user to the account manager URL if they visit /sign-up" do
      get "/sign-in", headers: { "GOVUK-Account-Session" => "placeholder" }
      assert_redirected_to Plek.find("account-manager")
    end
  end
end
