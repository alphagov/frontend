class FundingForm::CheckAnswersController < ApplicationController
  def show
    render "funding_form/check_answers"
  end

  def submit
    mailer = FundingFormMailer.with(form: session.to_h, reference_number: reference_number)
    mailer.confirmation_email(session[:email_address]).deliver_later
    mailer.department_email("helpdesk.grants.registration@cabinetoffice.gov.uk").deliver_later
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(10).upcase
    "#{timestamp}-#{random_id}"
  end
end
