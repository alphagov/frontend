require "gds_api/test_helpers/account_api"
require "gds_api/test_helpers/email_alert_api"

RSpec.describe "Sessions" do
  include GdsApi::TestHelpers::AccountApi
  include GdsApi::TestHelpers::EmailAlertApi
  include GovukPersonalisation::TestHelpers::Features

  before do
    # We add a fake content item pointed at homepage, which allows us to check we've
    # been redirected
    content_item = GovukSchemas::Example.find("homepage", example_name: "homepage_with_popular_links_on_govuk")
    base_path = content_item.fetch("base_path")
    stub_content_store_has_item(base_path, content_item)
  end

  after { Rails.application.reload_routes! }

  context "Given a signing in user" do
    it "Logs the user in and redirect them to manage their account" do
      given_a_successful_login_attempt
      visit new_govuk_session_callback_path(code: "code", state: "state")

      expect(page.current_url).to eq("#{GovukPersonalisation::Urls.one_login_your_services}/")
    end

    it "Logs the user in and send them to a redirect path if supplied" do
      redirect_path = "/?frequency=immediately&return_to_url=true&topic_id=some-page-with-notifications"
      given_a_successful_login_attempt(redirect_path:)
      visit new_govuk_session_callback_path(code: "code", state: "state")

      expect(page.current_url).to eq("http://www.example.com#{redirect_path}")
    end
  end

  def given_a_successful_login_attempt(redirect_path: nil)
    govuk_account_session = "session-id"
    stub_account_api_validates_auth_response(govuk_account_session:, redirect_path:)
    stub_account_api_user_info(new_govuk_account_session: govuk_account_session)
    stub_email_alert_api_authenticate_subscriber_by_govuk_account(govuk_account_session, "subscriber-id", "email@example.com")
    stub_email_alert_api_has_subscriber_subscriptions("subscriber-id", "example@example.com")
  end
end
