class SpeechPresenter < ContentItemPresenter
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

  def from
    super.tap do |f|
      f.push(speaker_without_profile) if speaker_without_profile
    end
  end

  def important_metadata
    # super.tap do |m|
    #   m.merge!(I18n.t("speech.location") => location, delivery_type => delivered_on_metadata)
    # end
    { I18n.t("formats.speech.location") => location, delivery_type => delivered_on_metadata }
  end

  def view_context
    @view_context = ApplicationController.new.view_context
  end

  def display_date(timestamp, format = "%-d %B %Y")
    I18n.l(Time.zone.parse(timestamp), format:, locale: "en") if timestamp
  end

private

  def location
    content_item.content_store_hash.dig("details", "location")
  end

  def delivered_on
    delivered_on_date = content_item.content_store_hash.dig("details", "delivered_on")
    view_context.tag.time(display_date(delivered_on_date), datetime: delivered_on_date)
  end

  def speech_type_explanation
    explanation = content_item.content_store_hash.dig("details", "speech_type_explanation")
    " (#{explanation})" if explanation
  end

  def speaker_without_profile
    content_item["details"]["speaker_without_profile"]
  end
end
