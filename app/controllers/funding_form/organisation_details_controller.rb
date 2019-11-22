class FundingForm::OrganisationDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/organisation_details"
  end

  def submit
    keys = %i[organisation_name address_line_1 address_line_2 address_town address_county address_postcode]
    mandatory_text_fields = %i[organisation_name address_line_1 address_town address_postcode]
    keys.each do |key|
      session[key] = sanitize(params[key])
    end
    invalid_fields = validate_mandatory_text_fields(mandatory_text_fields, "organisation_details")
    invalid_fields << validate_postcode("address_postcode", session[:address_postcode])
    invalid_fields = invalid_fields.flatten.uniq
    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "funding_form/organisation_details"
    else
      redirect_to controller: session["check_answers_seen"] ? "funding_form/check_answers" : "funding_form/companies_house_number", action: "show"
    end
  end
end
