class FundingForm::PartnersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper

  def show
    render "funding_form/partners"
  end

  def submit
    session[:partners_outside_uk] = sanitize(params[:partners_outside_uk])

    redirect_to controller: "funding_form/check_answers", action: "show"
  end
end
