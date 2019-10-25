class FundingForm::OrganisationTypeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/organisation_type"
  end

  def submit
    session[:organisation_type] = sanitize(params[:organisation_type_other]).presence || sanitize(params[:organisation_type])

    redirect_to controller: "funding_form/organisation_details", action: "show"
  end
end
