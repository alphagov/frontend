module ManualPageTitle
  def page_title
    title = content_item.title || ""
    title += " - " if title.present?

    if content_item.hmrc?
      I18n.t("formats.manuals.hmrc_title", title:)
    else
      I18n.t("formats.manuals.title", title:)
    end
  end
  alias_method :manual_page_title, :page_title
end
