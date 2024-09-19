module TitleHelper
  def title_and_context(title, document_type)
    {
      title:,
      context: I18n.t("formats.#{document_type}", count: 1),
      context_locale: t_locale_fallback("formats.#{document_type}", count: 1),
      average_title_length: "long",
    }
  end
end
