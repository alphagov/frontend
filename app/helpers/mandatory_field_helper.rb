module MandatoryFieldHelper
  def validate_mandatory_text_fields(mandatory_fields, page)
    invalid_fields = []
    mandatory_fields.each do |field|
      if session[field] == ""
        invalid_fields << { text: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.#{field}.label")).humanize }
      end
    end
    invalid_fields
  end

  def validate_date_fields(year, month, day, field)
    invalid_fields = []
    invalid_fields << { text: t("funding_form.errors.missing_year", field: field).humanize } if year == ""
    invalid_fields << { text: t("funding_form.errors.missing_month", field: field).humanize } if month == ""
    invalid_fields << { text: t("funding_form.errors.missing_day", field: field).humanize } if day == ""
    unless(invalid_fields != [] || Date.valid_date?(year.to_i, month.to_i, day.to_i))
      invalid_fields << { text: t("funding_form.errors.invalid_date", field: field).humanize }
    end
    invalid_fields
  end

  def validate_radio_field(page, radio:, other: false)
    if radio.blank?
      return [{ text: t("funding_form.errors.radio_field", field: t("funding_form.#{page}.title")).humanize }]
    end

    if other != false && other.blank? && %w(Yes Other).include?(radio)
      return [{ text: t("funding_form.errors.missing_mandatory_text_field", field: t("funding_form.#{page}.title")).humanize }]
    end

    []
  end
end
