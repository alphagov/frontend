class FundingForm::OrganisationTypeController < ApplicationController
  def show
    render "funding_form/organisation_type"
  end

  def submit
    session[:organisation_type] = params[:organisation_type_other] || params[:organisation_type]

    redirect_to controller: "funding_form/organisation_details", action: "show"
  end
end
