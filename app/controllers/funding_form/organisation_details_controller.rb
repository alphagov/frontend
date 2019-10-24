class FundingForm::OrganisationDetailsController < ApplicationController
  def show
    render "funding_form/organisation_details"
  end

  def submit
    keys = %i[organisation_name company_house_or_charity_commission_number address_line_1 address_line_2 address_town address_county address_postcode]
    keys.each do |key|
      session[key] = params[key]
    end
    redirect_to controller: "funding_form/grant_agreement_number", action: "show"
  end
end
