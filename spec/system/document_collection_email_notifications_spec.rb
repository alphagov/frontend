RSpec.describe "Document Collection Email Notifications" do
  include GovukPersonalisation::TestHelpers::Features

  let(:base_path) { content_item["base_path"] }
  let(:taxonomy_topic_base_path) { "/taxonomy_topic_base_path" }

  before { stub_content_store_has_item(base_path, content_item) }

  context "when a taxonomy topic email override is present and the page is in English" do
    let(:content_item) do
      GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
        item["links"]["taxonomy_topic_email_override"] = [{ "base_path" => taxonomy_topic_base_path.to_s }]
      end
    end

    it "renders a signup link" do
      visit base_path

      expect(page).to have_selector(".gem-c-signup-link")
      expect(page).to have_link(href: "/email-signup/confirm?topic=#{taxonomy_topic_base_path}")
      expect(page).not_to have_selector(".gem-c-single-page-notification-button")
    end
  end

  context "when a taxonomy topic email override is not present and the page is in English" do
    let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection") }

    it "renders a single page notification button with the /email-signup endpoint" do
      visit base_path

      form = page.find(".gem-c-single-page-notification-button > form")

      expect(form["action"]).to eq("/email-signup")
    end

    it "renders GA4 tracking for the button" do
      visit base_path

      expected_tracking = {
        "event_name" => "navigation",
        "type" => "subscribe",
        "index_link" => 1,
        "index_total" => 2,
        "section" => "Top",
        "url" => "/email-signup",
      }

      button = page.find(:button, class: "gem-c-single-page-notification-button__submit")

      expect(JSON.parse(button["data-ga4-link"])).to eq(expected_tracking)
    end
  end

  # def email_alert_frontend_signup_endpoint_enforce_account
  #   "/email/subscriptions/single-page/new"
  # end

  # test "renders the single page notification button with a form action of EmailAlertAPI's account-only endpoint for users logged into their gov.uk account" do
  #   # Need to use Rack as Selenium, the default driver, doesn't provide header access, and we need to set a govuk_account_session header
  #   Capybara.current_driver = :rack_test
  #   mock_logged_in_session
  #   setup_and_visit_content_item("document_collection", "locale" => "en")

  #   form = page.find(".gem-c-single-page-notification-button > form")
  #   assert_match(email_alert_frontend_signup_endpoint_enforce_account, form["action"])

  #   button = page.find(:button, class: "gem-c-single-page-notification-button__submit")

  #   expected_tracking = {
  #     "event_name" => "navigation",
  #     "type" => "subscribe",
  #     "index_link" => 1,
  #     "index_total" => 2,
  #     "section" => "Top",
  #     "url" => "/email/subscriptions/single-page/new",
  #   }

  #   actual_tracking = JSON.parse(button["data-ga4-link"])

  #   assert_equal expected_tracking, actual_tracking

  #   # reset back to default driver
  #   Capybara.use_default_driver
  # end

  # test "does not render the single page notification button if the page is in a foreign language" do
  #   setup_and_visit_content_item("document_collection", "locale" => "cy")
  #   assert_not page.has_css?(".gem-c-single-page-notification-button")
  # end

  # test "does not render the email signup link if the page is in a foreign language" do
  #   content_item = get_content_example("document_collection")
  #   content_item["links"]["taxonomy_topic_email_override"] = [{ "base_path" => taxonomy_topic_base_path.to_s }]
  #   content_item["locale"] = "cy"
  #   stub_content_store_has_item(content_item["base_path"], content_item)
  #   visit_with_cachebust(content_item["base_path"])
  #   assert_not page.has_css?(".gem-c-signup-link")
  # end
end
