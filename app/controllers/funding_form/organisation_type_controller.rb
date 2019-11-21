class FundingForm::OrganisationTypeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/organisation_type"
  end

  def submit
    organisation_type = sanitize(params[:organisation_type]).presence
    organisation_type_other = sanitize(params[:organisation_type_other]).presence

    session[:organisation_type] = organisation_type
    session[:organisation_type_other] = organisation_type == I18n.t("funding_form.organisation_type.options.other.label") ? organisation_type_other : ""

    invalid_fields = validate_radio_field(
      "organisation_type",
      radio: organisation_type,
      other: organisation_type_other,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "funding_form/organisation_type"
    else
      redirect_to controller: session["check_answers_seen"] ? "funding_form/check_answers" : "funding_form/organisation_details", action: "show"
    end
  end
end
