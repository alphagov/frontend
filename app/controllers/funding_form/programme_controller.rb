class FundingForm::ProgrammeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/programme"
  end

  def submit
    funding_programme = sanitize(params[:funding_programme])

    session[:funding_programme] = funding_programme

    invalid_fields = validate_radio_field(
      "programme",
      "funding_programme",
      radio: funding_programme,
    )

    if invalid_fields.any?
      flash[:validation] = invalid_fields
      render "funding_form/programme"
    else
      redirect_to controller: "funding_form/project_details", action: "show"
    end
  end
end
