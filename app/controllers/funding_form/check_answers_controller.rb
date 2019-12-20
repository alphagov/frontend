class FundingForm::CheckAnswersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    session[:check_answers_seen] = true
    render "funding_form/check_answers"
  end

  def submit
    session[:additional_comments] = sanitize(params[:additional_comments])
    submission_reference = reference_number

    mailer = FundingFormMailer.with(form: session.to_h, reference_number: submission_reference)
    mailer.confirmation_email(session[:email_address]).deliver_later

    department_grant_mapping.fetch(session[:project_name], []).each do |recipient_email|
      mailer.department_email(recipient_email).deliver_later
    end

    reset_session

    redirect_to controller: "funding_form/confirmation", action: "show", reference_number: submission_reference
  end

  def reference_number
    timestamp = Time.zone.now.strftime("%Y%m%d-%H%M%S")
    random_id = SecureRandom.hex(3).upcase
    "#{timestamp}-#{random_id}"
  end

private

  def department_grant_mapping
    {
      "Civil Protection Mechanism" => %w(rachel.ratcliffe@cabinet-office.x.gsi.gov.uk),
      "Competitiveness of Small and Medium-Sized Enterprises (COSME)" => %w(COSMEgrants@beis.gov.uk),
      "Connecting Europe Facility (CEF) telecoms" => %w(eu_exit_finance@culture.gov.uk),
      "Creative Europe" => %w(eu_exit_finance@culture.gov.uk),
      "Employment and Social Innovation (EaSI)" => %w(greg.mutyambizi@dwp.gov.uk),
      "Erasmus+" => %w(EGG.TECHSUPPORT@education.gov.uk),
      "Europe for Citizens" => %w(eu_exit_finance@culture.gov.uk),
      "European Solidarity Corps" => %w(andrew.hodgetts@culture.gov.uk ocseusubteam@culture.gov.uk),
      "Health for Growth" => %w(EU-Health-Programme@dhsc.gov.uk),
      "Rights, Equality, and Citizenship Programme (RECP)" => %w(rightsequalitiescitizenshipfund@homeoffice.gov.uk),
    }
  end
end
