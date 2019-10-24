class FundingForm::GrantAgreementNumberController < ApplicationController
  def show
    render "funding_form/grant_agreement_number"
  end

  def submit
    session[:grant_agreement_number] = params[:grant_agreement_number]
    redirect_to controller: "funding_form/programme", action: "show"
  end
end
