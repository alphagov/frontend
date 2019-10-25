class FundingForm::ContactInformationController < ApplicationController
  def show
    render "funding_form/contact_information"
  end

  def submit
    keys = %i[full_name job_title email_address telephone_number]
    keys.each do |key|
      session[key] = params[key]
    end
    redirect_to controller: "funding_form/organisation_type", action: "show"
  end
end
