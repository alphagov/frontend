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
        email_address: "test@test.com",
        telephone_number: "012345",
        organisation_type: "Computers",
        organisation_name: "A name",
        company_house_or_charity_commission_number: "789",
        address_line_1: "First line of address",
        address_line_2: "Second line of address",
        address_town: "Town of address",
        address_county: "County of address",
        address_postcode: "Postcode of address",
        grant_agreement_number: "999",
        funding_programme: "Erasmus",
        project_name: "Whitehall",
        total_amount_awarded: "1000",
        start_date: "24 October",
        end_date: "25 October",
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
