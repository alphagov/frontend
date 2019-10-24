class FundingForm::ProjectDetailsController < ApplicationController
  def show
    render "funding_form/project_details"
  end

  def submit
    keys = %i[project_name total_amount_awarded]
    keys.each do |key|
      session[key] = params[key]
    end
    session[:start_date] = DateTime.new(params[:start_date_year].to_i, params[:start_date_month].to_i, params[:start_date_day].to_i).strftime("%Y-%m-%d")
    session[:end_date] = DateTime.new(params[:end_date_year].to_i, params[:end_date_month].to_i, params[:end_date_day].to_i).strftime("%Y-%m-%d")
    redirect_to controller: "funding_form/check_answers", action: "show"
  end
end
