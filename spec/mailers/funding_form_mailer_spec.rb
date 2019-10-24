RSpec.describe FundingFormMailer do
  let(:email_address) { "test@example.com" }

  describe "#confirmation_email" do
    it "creates an email for the email address" do
      mail = described_class.with(to: email_address).confirmation_email

      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("Funding Form Confirmation")
      expect(mail.body.to_s).to include("Confirmation of funding form.")
    end
  end

  describe "#backend_email" do
    it "creates an email for the email address" do
      mail = described_class.backend_email(email_address)

      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("Funding Form")
      expect(mail.body.to_s).to include("Funding form submission.")
    end
  end
end
