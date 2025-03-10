class SpeechPresenter < ContentItemPresenter
  def speech_contributor_links
    return contributor_links unless content_item.speaker_without_profile

    contributor_links + [{ text: content_item.speaker_without_profile }]
  end

  def delivery_type
    return I18n.t("formats.speech.written_on") if content_item.document_type == "authored_article"

    I18n.t("formats.speech.delivered_on")
  end
end
