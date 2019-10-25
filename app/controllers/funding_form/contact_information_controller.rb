class FundingForm::ContactInformationController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/contact_information"
  end

  def submit
    keys = %i[full_name job_title email_address telephone_number]
    mandatory_text_fields = %i[full_name job_title email_address telephone_number]
    keys.each do |key|
      session[key] = sanitize(params[key])
    end
    invalid_fields = validate_mandatory_text_fields(mandatory_text_fields, "contact_information")
    if invalid_fields.any?
      flash[:validation] = invalid_fields
      render "funding_form/contact_information"
    else
      redirect_to controller: "funding_form/organisation_type", action: "show"
    end
  end
end
