class FundingForm::PartnersController < ApplicationController
  def show
    render "funding_form/partners"
  end

  def submit
    session[:partners_outside_uk] = params[:partners_outside_uk]

    redirect_to controller: "funding_form/check_answers", action: "show"
  end
end
