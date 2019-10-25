class FundingForm::OrganisationDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/organisation_details"
  end

  def submit
    keys = %i[organisation_name address_line_1 address_line_2 address_town address_county address_postcode]
    keys.each do |key|
      session[key] = sanitize(params[key])
    end
    redirect_to controller: "funding_form/companies_house_number", action: "show"
  end
end
