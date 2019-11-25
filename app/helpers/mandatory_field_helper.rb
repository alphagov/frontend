module MandatoryFieldHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      if session[field].blank?
        invalid_fields << { field: field.to_s,
                            text: t("funding_form.#{page}.#{field}.custom_error",
                                    default: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.#{field}.label")).humanize) }
      end
    end
    invalid_fields
  end

  def validate_date_fields(year, month, day, field)
    return [] if year.blank? && month.blank? && day.blank?

    invalid_fields = []
    invalid_fields << { field: field.to_s, text: t("funding_form.errors.missing_year", field: field).humanize } if year.blank?
    invalid_fields << { field: field.to_s, text: t("funding_form.errors.missing_month", field: field).humanize } if month.blank?
    invalid_fields << { field: field.to_s, text: t("funding_form.errors.missing_day", field: field).humanize } if day.blank?
    unless(invalid_fields != [] || Date.valid_date?(year.to_i, month.to_i, day.to_i))
      invalid_fields << { field: field.to_s, text: t("funding_form.errors.invalid_date", field: field).humanize }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, other: false)
    if radio.blank?
      return [{ field: page.to_s,
                text: t(
                  "funding_form.#{page}.custom_select_error",
                  default: t("funding_form.errors.radio_field", field: t("funding_form.#{page}.title")).humanize,
                ) }]
    end

    if other != false && other.blank? && %w(Yes Other).include?(radio)
      return [{ field: page.to_s,
                text: t(
                  "funding_form.#{page}.custom_enter_error",
                  default: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.title")).humanize,
                ) }]
    end

    []
  end

  def validate_date_order(start_date, end_date, field)
    if end_date < start_date
      [{ field: field.to_s, text: t("funding_form.errors.date_order") }]
    else
      []
    end
  end

  def validate_email_address(field, email_address)
    if email_address =~ /@/
      []
    else
      [{ field: field.to_s, text: t("funding_form.errors.email_format") }]
    end
  end

  def validate_postcode(field, postcode)
    if postcode =~ /^(([A-Z]{1,2}[0-9][A-Z0-9]?|ASCN|STHL|TDCU|BBND|[BFS]IQQ|PCRN|TKCA) ?[0-9][A-Z]{2}|BFPO ?[0-9]{1,4}|(KY[0-9]|MSR|VG|AI)[ -]?[0-9]{4}|[A-Z]{2} ?[0-9]{2}|GE ?CX|GIR ?0A{2}|SAN ?TA1)$/i
      []
    else
      [{ field: field.to_s, text: t("funding_form.errors.postcode_format") }]
    end
  end
end
