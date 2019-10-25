class FundingForm::CompaniesHouseNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/companies_house_number"
  end

  def submit
    company_house_or_charity_commision_number = sanitize(params[:company_house_or_charity_commision_number]).presence
    company_house_or_charity_commision_number_other = sanitize(params[:company_house_or_charity_commision_number_other]).presence

    session[:company_house_or_charity_commision_number] = company_house_or_charity_commision_number_other || company_house_or_charity_commision_number

    invalid_fields = validate_radio_field(
      "companies_house_number",
      "company_house_or_charity_commision_number",
      radio: company_house_or_charity_commision_number,
      other: company_house_or_charity_commision_number_other,
    )

    if invalid_fields.any?
      flash[:validation] = invalid_fields
      render "funding_form/companies_house_number"
    else
      redirect_to controller: "funding_form/grant_agreement_number", action: "show"
    end
  end
end
