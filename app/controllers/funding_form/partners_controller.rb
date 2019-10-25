class FundingForm::PartnersController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/partners"
  end

  def submit
    partners_outside_uk = sanitize(params[:partners_outside_uk])

    session[:partners_outside_uk] = partners_outside_uk

    invalid_fields = validate_radio_field(
      "partners",
      "partners_outside_uk",
      radio: partners_outside_uk,
    )

    if invalid_fields.any?
      flash[:validation] = invalid_fields
      render "funding_form/partners"
    else
      redirect_to controller: "funding_form/check_answers", action: "show"
    end
  end
end
