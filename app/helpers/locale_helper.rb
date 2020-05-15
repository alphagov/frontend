module LocaleHelper
  def lang_attribute(locale)
    "lang=#{locale}" unless I18n.default_locale.to_s == locale.to_s
  end
end
