RSpec.describe FundingFormMailer do
  let(:email_address) { "test@example.com" }

  describe "#confirmation_email" do
    it "creates an email for the email address" do
      mail = described_class.with(to: email_address).confirmation_email

      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("Funding Form Confirmation")
      expect(mail.body.to_s).to include("Thank you for filling in the funding form.")
    end
  end

  describe "#department_email" do
    let(:form) do
      {
        full_name: "Someone",
        job_title: "Developer",
      }
    end

    it "creates an email for the email address" do
      mail = described_class.with(to: email_address, form: form).department_email

      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("Funding Form Submission")
      form.values.each do |value|
        expect(mail.body.to_s).to include(value)
      end
    end
  end
end
