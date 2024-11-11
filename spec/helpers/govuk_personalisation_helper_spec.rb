RSpec.describe GovukPersonalisationHelper do
  include described_class

  describe "#email_subscription_success_banner_heading" do
    it "displays the subscription success banner when the 'email-subscription-success' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-success])
      expect(email_subscription_success_banner_heading(account_flash)).to eq(t("email.subscribe_title"))
    end

    it "displays the unsubscription success banner when the 'email-unsubscribe-success' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-unsubscribe-success])
      expect(email_subscription_success_banner_heading(account_flash)).to eq(t("email.unsubscribe_title"))
    end

    it "displays the subscription already subscribed banner when the 'email-subscription-already-subscribed' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-already-subscribed])
      expect(email_subscription_success_banner_heading(account_flash)).to eq(t("email.already_subscribed_title"))
    end

    it "does not display a banner when the flash is not present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", [])
      expect(email_subscription_success_banner_heading(account_flash)).to be_nil
    end
  end

  describe "#show_email_subscription_success_banner?" do
    it "returns true when the 'email-subscription-success' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-success])
      expect(show_email_subscription_success_banner?(account_flash)).to be(true)
    end

    it "returns true when the 'email-unsubscribe-success' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-unsubscribe-success])
      expect(show_email_subscription_success_banner?(account_flash)).to be(true)
    end

    it "returns true when the 'email-subscription-already-subscribed' flash is present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", %w[email-subscription-already-subscribed])
      expect(show_email_subscription_success_banner?(account_flash)).to be(true)
    end

    it "returns false when a flash is not present" do
      account_flash = GovukPersonalisation::Flash.encode_session("session-id", [])
      expect(show_email_subscription_success_banner?(account_flash)).to be(false)
    end
  end
end
