class FundingFormMailer < ApplicationMailer
  self.delivery_job = EmailDeliveryJob

  def confirmation_email
    email_address = params[:to]
    mail(to: email_address, subject: "Funding Form Confirmation")
  end

  def department_email
    email_address = params[:to]
    @form = params[:form]
    mail(to: email_address, subject: "Funding Form Submission")
  end
end
