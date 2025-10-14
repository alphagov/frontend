class CallForEvidencePresenter < ContentItemPresenter
  def opens_closes_or_ran
    if content_item.closed?
      I18n.t("formats.call_for_evidence.ran_from")
    elsif content_item.open?
      I18n.t("formats.call_for_evidence.closes_at")
    else
      "#{I18n.t('formats.call_for_evidence.opens')} #{I18n.t('common.at')}"
    end
  end

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
