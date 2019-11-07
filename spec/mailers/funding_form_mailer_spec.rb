RSpec.describe FundingFormMailer do
  let(:email_address) { "test@example.com" }

  let(:form) do
    {
      "full_name" => "Someone",
      "job_title" => "Developer",
      "email_address" => "test@test.com",
      "telephone_number" => "012345",
      "organisation_type" => "Computers",
      "organisation_name" => "A name",
      "companies_house_or_charity_commission_number" => "789",
      "address_line_1" => "First line of address",
      "address_line_2" => "Second line of address",
      "address_town" => "Town of address",
      "address_county" => "County of address",
      "address_postcode" => "Postcode of address",
      "grant_agreement_number" => "999",
      "funding_programme" => "Erasmus",
      "project_name" => "Whitehall",
      "total_amount_awarded" => "1000",
      "award_start_date" => "24 October",
      "award_end_date" => "25 October",
      "partners_outside_uk" => "Yes",
      "additional_comments" => "This is a\ncomment.",
    }
  end

  let(:reference_number) { "REF-ABC" }

  subject(:mailer) do
    described_class.with(form: form, reference_number: reference_number)
  end

  describe "#confirmation_email" do
    subject(:mail) { mailer.confirmation_email(email_address) }

    it "creates an email for the email address" do
      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("You’ve registered as an organisation getting EU funding")
      expect(mail.body.to_s).to include("Dear #{form['full_name']}")
      expect(mail.body.to_s).to include("You’ve registered #{form['organisation_name']}")
      expect(mail.body.to_s).to include(reference_number)
    end
  end

  describe "#department_email" do
    subject(:mail) { mailer.department_email(email_address) }

    it "creates an email for the email address" do
      expect(mail.to).to eq([email_address])
      expect(mail.subject).to eq("Registration as a recipient of EU funding")
      form.except("additional_comments").values.each do |value|
        expect(mail.body.to_s).to include(value)
      end
      expect(mail.body.to_s).to include("|First line of address, Second line of address, Town of address, County of address|")
      expect(mail.body.to_s).to include("|This is a comment.")
      expect(mail.body.to_s).to include(reference_number)
    end
  end
end
