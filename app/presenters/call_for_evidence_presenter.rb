class CallForEvidencePresenter < ContentItemPresenter
  include DateHelper
  include LinkHelper

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

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
        see_updates_link: true,
      }
    })
  end
end
