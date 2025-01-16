class SpeechPresenter < ContentItemPresenter
  include DateHelper

  def initialize(content_item, view_context)
    @view_context = view_context

    super(content_item)
  end

  def delivery_type
    if content_item.document_type == "authored_article"
      I18n.t("formats.speech.written_on")
    else
      I18n.t("formats.speech.delivered_on")
    end
  end

  def delivered_on_metadata
    "#{delivered_on}#{speech_type_explanation}"
  end

  def important_metadata
    { I18n.t("formats.speech.location") => location, delivery_type => delivered_on_metadata }
  end

private

  def location
    content_item.content_store_hash.dig("details", "location")
  end

  def delivered_on
    delivered_on_date = content_item.content_store_hash.dig("details", "delivered_on")
    @view_context.tag.time(display_date(delivered_on_date), datetime: delivered_on_date)
  end

  def speech_type_explanation
    explanation = content_item.content_store_hash.dig("details", "speech_type_explanation")
    " (#{explanation})" if explanation
  end
end
