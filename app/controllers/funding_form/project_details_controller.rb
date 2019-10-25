class FundingForm::ProjectDetailsController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/project_details"
  end

  def submit
    keys = %i[project_name total_amount_awarded start_date_year start_date_month start_date_day end_date_year end_date_month end_date_day]
    mandatory_text_fields = %i[project_name]
    keys.each do |key|
      session[key] = sanitize(params[key])
    end
    invalid_fields = validate_mandatory_text_fields(mandatory_text_fields, "project_details")
    session[:award_start_date] = DateTime.new(params[:start_date_year].to_i, params[:start_date_month].to_i, params[:start_date_day].to_i).strftime("%Y-%m-%d")
    session[:award_end_date] = DateTime.new(params[:end_date_year].to_i, params[:end_date_month].to_i, params[:end_date_day].to_i).strftime("%Y-%m-%d")
    if invalid_fields.any?
      flash[:validation] = invalid_fields
      render "funding_form/project_details"
    else
      redirect_to controller: "funding_form/partners", action: "show"
    end
  end
end
