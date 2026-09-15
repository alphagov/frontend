class SpeechPresenter < ContentItemPresenter
  include LinkHelper
  include DateHelper

  def use_contextual_components?
    true
  end

  def page_title_options
    super.merge({
      metadata: {
        from: govuk_styled_links_list(speech_contributor_links),
        first_published: display_date(content_item.initial_publication_date),
        last_updated: display_date(content_item.updated),
        see_updates_link: true,
      },
    })
  end

  def speech_contributor_links
    return contributor_links unless content_item.speaker_without_profile

    contributor_links + [{ text: content_item.speaker_without_profile }]
  end

  def delivery_type
    return I18n.t("formats.speech.written_on") if content_item.document_type == "authored_article"

    I18n.t("formats.speech.delivered_on")
  end
end
