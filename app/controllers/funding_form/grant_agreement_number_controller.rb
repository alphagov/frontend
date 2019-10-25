class FundingForm::GrantAgreementNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/grant_agreement_number"
  end

  def submit
    session[:grant_agreement_number] = sanitize(params[:grant_agreement_number_other]).presence || sanitize(params[:grant_agreement_number])
    redirect_to controller: "funding_form/programme", action: "show"
  end
end
