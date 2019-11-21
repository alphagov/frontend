class FundingFormMailer < ApplicationMailer
  self.delivery_job = EmailDeliveryJob

  def confirmation_email(email_address)
    @form = params[:form]
    @reference_number = params[:reference_number]
    mail(to: email_address, subject: "You’ve registered as an organisation getting EU funding")
  end

  def department_email(email_address)
    @form = params[:form]
    @reference_number = params[:reference_number]
    @address = [
      @form["address_line_1"].presence,
      @form["address_line_2"].presence,
      @form["address_town"].presence,
      @form["address_county"].presence,
    ].compact.join(", ")
    @copy_and_paste_line = [
      @form["full_name"],
      @form["job_title"],
      @form["email_address"],
      @form["telephone_number"],
      @form["organisation_type_other"].presence || @form["organisation_type"],
      @form["organisation_name"],
      @form["companies_house_or_charity_commission_number"],
      @address,
      @form["address_postcode"],
      @form["grant_agreement_number"],
      @form["funding_programme"],
      @form["project_name"],
      @form["total_amount_awarded"],
      @form["award_start_date"],
      @form["award_end_date"],
      @form["partners_outside_uk"],
      @form["additional_comments"]&.squish,
    ].join("|")
    mail(to: email_address, subject: "Registration as a recipient of EU funding")
  end
end
