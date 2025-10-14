class ConsultationPresenter < ContentItemPresenter
  def on_or_at
    opening_date_midnight? ? I18n.t("common.on") : I18n.t("common.at")
  end

  def opens_closes_or_ran
    if content_item.closed?
      I18n.t("formats.consultation.ran_from")
    elsif content_item.open?
      I18n.t("formats.consultation.closes_at")
    else
      "#{I18n.t('formats.consultation.opens')} #{I18n.t('common.at')}"
    end
  end

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

private

  def opening_date_midnight?
    Time.zone.parse(content_item.opening_date_time).strftime("%l:%M%P") == "12:00am"
  end
end
