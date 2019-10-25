class FundingForm::CompaniesHouseNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/companies_house_number"
  end

  def submit
    session[:company_house_or_charity_commision_number] = sanitize(params[:company_house_or_charity_commision_number_other]).presence || sanitize(params[:company_house_or_charity_commision_number])
    redirect_to controller: "funding_form/grant_agreement_number", action: "show"
  end
end
