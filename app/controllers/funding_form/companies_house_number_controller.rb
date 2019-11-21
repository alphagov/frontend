class FundingForm::CompaniesHouseNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/companies_house_number"
  end

  def submit
    companies_house_or_charity_commission_number = sanitize(params[:companies_house_or_charity_commission_number]).presence
    companies_house_or_charity_commission_number_other = sanitize(params[:companies_house_or_charity_commission_number_other]).presence

    session[:companies_house_or_charity_commission_number_boolean] = companies_house_or_charity_commission_number
    session[:companies_house_or_charity_commission_number] = companies_house_or_charity_commission_number == I18n.t("funding_form.companies_house_or_charity_commission_number.options.number_yes.label") ? companies_house_or_charity_commission_number_other : ""

    invalid_fields = validate_radio_field(
      "companies_house_or_charity_commission_number",
      radio: companies_house_or_charity_commission_number,
      other: companies_house_or_charity_commission_number_other,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "funding_form/companies_house_number"
    else
      redirect_to controller: session["check_answers_seen"] ? "funding_form/check_answers" : "funding_form/grant_agreement_number", action: "show"
    end
  end
end
