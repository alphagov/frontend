module LocaleHelper
  def lang_attribute(locale)
    "lang=#{locale}" unless I18n.default_locale.to_s == locale.to_s
  end

  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end
end
