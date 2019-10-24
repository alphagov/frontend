class FundingFormMailer < ApplicationMailer
  self.delivery_job = EmailDeliveryJob

  def confirmation_email
    email_address = params[:to]
    mail(to: email_address, subject: "Funding Form Confirmation")
  end

  def backend_email(email_address)
    mail(to: email_address, subject: "Funding Form")
  end
end
