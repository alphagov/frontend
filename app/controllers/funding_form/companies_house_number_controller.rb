class FundingForm::CompaniesHouseNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/companies_house_number"
  end

  def submit
    session[:companies_house_or_charity_commission_number] = sanitize(params[:companies_house_or_charity_commission_number_other]).presence || sanitize(params[:companies_house_or_charity_commission_number])
    redirect_to controller: "funding_form/grant_agreement_number", action: "show"
  end
end
