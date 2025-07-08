RSpec.describe "Document Collection Email Notifications" do
  include GovukPersonalisation::TestHelpers::Features

  let(:base_path) { content_item["base_path"] }
  let(:taxonomy_topic_base_path) { "/taxonomy_topic_base_path" }

  before { stub_content_store_has_item(base_path, content_item) }

  context "when a taxonomy topic email override is present" do
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

    context "and when the page is not in english" do
      let(:content_item) do
        GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
          item["links"]["taxonomy_topic_email_override"] = [{ "base_path" => taxonomy_topic_base_path.to_s }]
          item["locale"] = "es"
        end
      end

      it "does not render the signup link" do
        visit base_path

        expect(page).not_to have_selector(".gem-c-signup-link")
      end
    end
  end

  context "when a taxonomy topic email override is not present" do
    let(:content_item) { GovukSchemas::Example.find(:document_collection, example_name: "document_collection") }

    it "renders a single page notification button with the /email-signup endpoint" do
      visit base_path

      form = page.find(".gem-c-single-page-notification-button > form")

      expect(form["action"]).to eq("/email-signup")
    end

    it "renders GA4 tracking with the /email-signup endpoint" do
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

    context "and when the user is logged in" do
      before { mock_logged_in_session }

      it "renders the single page notification button with the account-only endpoint" do
        visit base_path

        form = page.find(".gem-c-single-page-notification-button > form")

        expect(form["action"]).to eq("/email/subscriptions/single-page/new")
      end

      it "renders GA4 tracking with the account-only endpoint" do
        visit base_path

        expected_tracking = {
          "event_name" => "navigation",
          "type" => "subscribe",
          "index_link" => 1,
          "index_total" => 2,
          "section" => "Top",
          "url" => "/email/subscriptions/single-page/new",
        }

        button = page.find(:button, class: "gem-c-single-page-notification-button__submit")

        expect(JSON.parse(button["data-ga4-link"])).to eq(expected_tracking)
      end
    end

    context "but when the page is not in english" do
      let(:content_item) do
        GovukSchemas::Example.find(:document_collection, example_name: "document_collection").tap do |item|
          item["locale"] = "cy"
        end
      end

      it "does not render the single page notification button" do
        visit base_path

        expect(page).not_to have_selector(".gem-c-single-page-notification-button")
      end
    end
  end
end
