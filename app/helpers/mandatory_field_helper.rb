module MandatoryFieldHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      if session[field].blank?
        invalid_fields << { text: t("funding_form.#{page}.#{field}.custom_error",
                                    default: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.#{field}.label")).humanize) }
      end
    end
    invalid_fields
  end

  def validate_date_fields(year, month, day, field)
    return [] if year.blank? && month.blank? && day.blank?

    invalid_fields = []
    invalid_fields << { text: t("funding_form.errors.missing_year", field: field).humanize } if year.blank?
    invalid_fields << { text: t("funding_form.errors.missing_month", field: field).humanize } if month.blank?
    invalid_fields << { text: t("funding_form.errors.missing_day", field: field).humanize } if day.blank?
    unless(invalid_fields != [] || Date.valid_date?(year.to_i, month.to_i, day.to_i))
      invalid_fields << { text: t("funding_form.errors.invalid_date", field: field).humanize }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, other: false)
    if radio.blank?
      return [{ text: t("funding_form.#{page}.custom_select_error",
                        default: t("funding_form.errors.radio_field", field: t("funding_form.#{page}.title")).humanize) }]
    end

    if other != false && other.blank? && %w(Yes Other).include?(radio)
      return [{ text: t("funding_form.#{page}.custom_enter_error",
                        default: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.title")).humanize) }]
    end

    []
  end

  def validate_date_order(start_date, end_date)
    if end_date < start_date
      [{ text: t("funding_form.errors.date_order") }]
    else
      []
    end
  end
end
