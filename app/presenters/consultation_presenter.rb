class ConsultationPresenter < ContentItemPresenter
  def notice_title
    if content_item.unopened?
      I18n.t("formats.consultation.not_open_yet")
    elsif content_item.pending_final_outcome?
      I18n.t("formats.consultation.analysing_feedback")
    elsif content_item.outcome?
      I18n.t("formats.consultation.concluded")
    else
      ""
    end
  end

  def notice_description
    if content_item.unopened?
      I18n.t("formats.consultation.opens")
    elsif content_item.pending_final_outcome?
      I18n.t("formats.consultation.visit_soon")
    else
      ""
    end
  end
end
