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

  def validate_radio_field(page, field, radio:, other: false)
    if radio.blank?
      return [{ text: t("funding_form.errors.radio_field") + t("funding_form.#{page}.#{field}.label") }]
    end

    if other != false && other.blank? && (radio == "Other" || radio == "Yes")
      return [{ text: t("funding_form.errors.missing_mandatory_text_field") + t("funding_form.#{page}.#{field}.label") }]
    end

    []
  end
end
