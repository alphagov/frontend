RSpec.describe "published dates with notification button" do
  let(:content_store_response) { GovukSchemas::Example.find("detailed_guide", example_name: "detailed_guide") }

  let(:content_item) { DetailedGuide.new(content_store_response) }

  before do
    assign(:content_item, content_item)
    allow(view).to receive(:logged_in?).and_return(false)
  end

  context "when there is single page notification button" do
    before { allow(content_item).to receive(:display_single_page_notification_button?).and_return(true) }

    it "renders the email and print link text" do
      render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item }

      expect(rendered).to include(I18n.t("common.email_and_print_link"))
    end

    it "renders an email pointing to the account-only signup endpoint" do
      render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item }

      expect(rendered).to include("/email/subscriptions/single-page/new")
    end

    context "and when skip_account is set to \"true\"" do
      it "renders an email pointing to the simple signup endpoint" do
        render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item, skip_account: "true" }

        expect(rendered).to include("/email-signup")
      end
    end
  end

  context "when there is no single page notification button" do
    it "renders the print link text only" do
      allow(content_item).to receive(:display_single_page_notification_button?).and_return(false)

      render partial: "shared/published_dates_with_notification_button", locals: { content_item: content_item }

      expect(rendered).to include(I18n.t("common.print_link"))
    end
  end
end
