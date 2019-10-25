class FundingForm::CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/check_answers"
  end

  def submit
    session[:additonal_comments] = sanitize(params[:additonal_comments])
    submission_reference = reference_number

    mailer = FundingFormMailer.with(form: session.to_h, reference_number: submission_reference)
    mailer.confirmation_email(session[:email_address]).deliver_later
    mailer.department_email("grants.registration@cabinetoffice.gov.uk").deliver_later

    redirect_to controller: "funding_form/confirmation", action: "show", reference_number: submission_reference
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end
end
