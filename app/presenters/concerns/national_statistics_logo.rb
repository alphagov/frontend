module NationalStatisticsLogo
  def logo
    return unless content_item.national_statistics?
    return unless %w[en cy].include?(content_item.locale)

    {
      path: "accredited-official-statistics-#{content_item.locale}.png",
      alt_text: I18n.t("national_statistics.logo_alt_text", locale: content_item.locale),
    }
  end
end
