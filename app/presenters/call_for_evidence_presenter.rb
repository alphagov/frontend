class CallForEvidencePresenter < ContentItemPresenter
  def notice_title
    if content_item.unopened?
      I18n.t("formats.call_for_evidence.not_open_yet")
    elsif content_item.outcome?
      I18n.t("formats.call_for_evidence.closed")
    else
      ""
    end
  end

  def notice_description
    content_item.unopened? ? I18n.t("formats.call_for_evidence.opens") : ""
  end
end
