class FundingForm::GrantAgreementNumberController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  include MandatoryFieldHelper

  def show
    render "funding_form/grant_agreement_number"
  end

  def submit
    grant_agreement_number = sanitize(params[:grant_agreement_number]).presence
    grant_agreement_number_other = sanitize(params[:grant_agreement_number_other]).presence

    session[:grant_agreement_number_boolean] = grant_agreement_number
    session[:grant_agreement_number] = grant_agreement_number == I18n.t("funding_form.grant_agreement_number.options.grant_yes") ? grant_agreement_number_other : ""

    invalid_fields = validate_radio_field(
      "grant_agreement_number",
      radio: grant_agreement_number,
      other: grant_agreement_number_other,
    )

    if invalid_fields.any?
      flash.now[:validation] = invalid_fields
      render "funding_form/grant_agreement_number"
    else
      redirect_to controller: session["check_answers_seen"] ? "funding_form/check_answers" : "funding_form/programme", action: "show"
    end
  end
end
