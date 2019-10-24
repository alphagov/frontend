class FundingForm::ProgrammeController < ApplicationController
  def show
    render "funding_form/programme"
  end

  def submit
    session[:funding_programme] = params[:funding_programme]

    redirect_to controller: "funding_form/project_details", action: "show"
  end
end
