class ConsultationPresenter < ContentItemPresenter
  include LinkHelper
  include DateHelper

  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
        see_updates_link: true,
      },
    })
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
end
