class FundingFormMailer < ApplicationMailer
  def confirmation_email(email_address)
    mail(to: email_address, subject: "Funding Form Confirmation")
  end

  def backend_email(email_address)
    mail(to: email_address, subject: "Funding Form")
  end
end
