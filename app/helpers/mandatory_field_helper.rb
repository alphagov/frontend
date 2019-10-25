module MandatoryFieldHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      if session[field] == ""
        invalid_fields << { text: t("funding_form.errors.missing_mandatory_text_field") + t("funding_form.#{page}.#{field}.label") }
      end
    end
    invalid_fields
  end

  def validate_date_fields(year, month, day, field)
    invalid_fields = []
    invalid_fields << { text: t("funding_form.errors.missing_year", field: field) } if year == ""
    invalid_fields << { text: t("funding_form.errors.missing_month", field: field) } if month == ""
    invalid_fields << { text: t("funding_form.errors.missing_day", field: field) } if day == ""
    unless(Date.valid_date?(year.to_i, month.to_i, day.to_i))
      invalid_fields << { text: t("funding_form.errors.invalid_date", field: field) }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, other: false)
    if radio.blank?
      return [{ text: t("funding_form.errors.radio_field") + t("funding_form.#{page}.title") }]
    end

    if other != false && other.blank? && %w(Yes Other).include?(radio)
      return [{ text: t("funding_form.errors.missing_mandatory_text_field") + t("funding_form.#{page}.title") }]
    end

    []
  end
end
