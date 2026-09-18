class GonePresenter < ContentItemPresenter
  def page_title_options
    super.merge({
      heading_text: I18n.t("gone.title"),
      heading_locale: I18n.locale,
    })
  end
end
