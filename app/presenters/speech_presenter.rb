class SpeechPresenter < ContentItemPresenter
  def delivery_type
    return I18n.t("formats.speech.written_on") if content_item.document_type == "authored_article"

    I18n.t("formats.speech.delivered_on")
  end
end
