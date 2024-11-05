module LocaleHelper
  def lang_attribute(locale)
    "lang=#{locale}" unless I18n.default_locale.to_s == locale.to_s
  end

  def page_text_direction
    I18n.t("i18n.direction", locale: I18n.locale, default: "ltr")
  end

  def native_language_name_for(locale)
    I18n.t("language_names.#{locale}", locale:)
  end

  def translations_for_nav(translations)
    translations.map do |translation|
      {
        locale: translation["locale"],
        base_path: translation["base_path"],
        text: native_language_name_for(translation["locale"]),
      }.tap do |h|
        h[:active] = true if h[:locale] == I18n.locale.to_s
      end
    end
  end

  def t_locale_fallback(key, options = {})
    options[:locale] = I18n.locale
    options[:fallback] = nil
    translation = I18n.t(key, **options)

    if translation.nil? || translation.downcase.include?("translation missing")
      I18n.default_locale
    end
  end
end
